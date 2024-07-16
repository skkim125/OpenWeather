//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation
import MapKit

final class WeatherViewModel {
    private let owManager = OpenWeatherManager.shared
    private let userdefaultsManager = UserDefaultsManager.shared
    
    var inputCityID: Observable<Int> = Observable(0) // 입력 받는 id
    var inputCityList: Observable<[City]> = Observable([])
    var inputCurrentWeather: Observable<Weather?> = Observable(nil)
    var inputSubWeather: Observable<SubWeather?> = Observable(nil)
    
    var outputCityID: Observable<Int> = Observable(0) // 호출 id
    var outputCity: Observable<City?> = Observable(nil)
    var outputCurrentTemperature: Observable<String> = Observable("")
    var outputMaxAndMinTemperature: Observable<String> = Observable("")
    var outputWeatherOverview: Observable<String?> = Observable(nil)
    var outputWindSpeed: Observable<String?> = Observable(nil)
    var outputCloudy: Observable<String?> = Observable(nil)
    var outputPressure: Observable<String?> = Observable(nil)
    var outputHumidity: Observable<String?> = Observable(nil)
    var outputMapCoord: Observable<CLLocationCoordinate2D?> = Observable(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    var outputShowAlert: Observable<Bool> = Observable(false)
    var outputFiveDays: Observable<[String]> = Observable([])
    var outputMinMaxTempOfDay: Observable<[String: (Weather, Weather)]> = Observable([:])
    
    init() {
        
        fetchJson()
        
        inputCityID.value = userdefaultsManager.savedID
        inputCityID.bind { id in
            if id != 0 {
                self.outputCityID.value = id
                self.outputCity.value = self.inputCityList.value.filter({ $0.id == id }).first!
            } else {
                self.outputCityID.value = 1835847
            }
        }
        
        outputCityID.bind { id in
            self.outputMapCoord.value = CLLocationCoordinate2D(latitude: self.outputCity.value?.coord.lat ?? 0.0, longitude: self.outputCity.value?.coord.lon ?? 0.0)
            self.callWeather(id: id)
        }
        
        inputCurrentWeather.bind { current in
            self.outputCurrentTemperature.value = current?.weatherDetail.tempStr ?? "--º"
            
            self.outputWeatherOverview.value = current?.weatherImage.first?.description ?? "--"
            
            self.outputWindSpeed.value = String(format: "%.2f", current?.wind.speed ?? 0.0) + "m/s"
            
            self.outputCloudy.value = "\(Int(current?.clouds.all ?? 0.0))" + "%"
            self.outputPressure.value = NumberFormatter.localizedString(from: (current?.weatherDetail.pressure ?? 0) as NSNumber, number: .decimal) + "hpa"
            self.outputHumidity.value = NumberFormatter.localizedString(from: (current?.weatherDetail.humidity ?? 0) as NSNumber, number: .decimal) + "%"
            
        }
    }
    
    private func callWeather(id: Int) {
        self.owManager.callRequest(api: .currentURL(id), requestAPIType: Weather.self) { data in
            if let data = data {
                self.inputCurrentWeather.value = data
                self.outputShowAlert.value = false
            } else {
                self.outputShowAlert.value = true
            }
        }
        
        self.owManager.callRequest(api: .subWeatherURL(id), requestAPIType: SubWeather.self) { data in
            if let data = data {
                self.inputSubWeather.value = data
                self.outputMapCoord.value = CLLocationCoordinate2D(latitude: data.city.coord.lat, longitude: data.city.coord.lon)
                self.outputShowAlert.value = false
                self.addMinMaxTemp(data: data)
                self.outputFiveDays.value = self.mappingFiveDays(fiveDays: data.fiveDays)
                if let day = self.inputCurrentWeather.value?.day {
                    self.setOutputMaxAndMinTemperature(day: day)
                }
            } else {
                self.outputShowAlert.value = true
            }
        }
    }
    
    private func fetchJson() {
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json"), let jsonStr = try? String(contentsOfFile: path) else {
            return
        }
        
        let decoder = JSONDecoder()
        let data = jsonStr.data(using: .utf8)
        
        if let data = data,
           let cities = try? decoder.decode([City].self, from: data) {
            inputCityList.value = cities
        }
    }
    
    private func addMinMaxTemp(data: SubWeather) {
        for weather in data.fiveDays {
            let day = weather.day
            
            let tempMin = weather.weatherDetail.temp_min
            let tempMax = weather.weatherDetail.temp_max
            if let value = outputMinMaxTempOfDay.value[day] {
                let minWeather = (tempMin < value.0.weatherDetail.temp_min) ? weather : value.0
                let maxWeather = (tempMax > value.1.weatherDetail.temp_max) ? weather : value.1
                
                outputMinMaxTempOfDay.value[day] = (minWeather, maxWeather)
            } else {
                outputMinMaxTempOfDay.value[day] = (weather, weather)
            }
        }
    }
    
    func setOutputMaxAndMinTemperature(day: String) {
        let cwMinTemp: String? = String(self.outputMinMaxTempOfDay.value[day]?.0.weatherDetail.temp_min ?? 0.0)
        let cwMaxTemp: String? = String(self.outputMinMaxTempOfDay.value[day]?.1.weatherDetail.temp_max ?? 0.0)
        
        self.outputMaxAndMinTemperature.value = "최고: \(cwMaxTemp ?? "--")º | 최저: \(cwMinTemp ?? "--")º"
    }
    
    func mappingFiveDays(fiveDays: [Weather]) -> [String] {
        let mapping = fiveDays.map({ $0.day })
        return Array(Set(mapping)).sorted(by: { $0 < $1 })
    }
}
