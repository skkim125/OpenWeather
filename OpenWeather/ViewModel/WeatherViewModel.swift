//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation
import MapKit

class WeatherViewModel {
    private let owManager = OpenWeatherManager.shared
    private let userdefaultsManager = UserDefaultsManager.shared
    
    var inputCityID: Observable<Int> = Observable(0) // 입력 받는 id
    var inputCityList: Observable<[City]> = Observable([])
    var inputCurrentWeather: Observable<Weather?> = Observable(nil)
    var inputSubWeather: Observable<SubWeather?> = Observable(nil)
    
    var outputCityID: Observable<Int> = Observable(0) // 호출 id
    var outputCity: Observable<City?> = Observable(nil)
    var outputCurrentTemperature: Observable<String?> = Observable(nil)
    var outputMaxAndMinTemperature: Observable<String?> = Observable(nil)
    var outputWeatherOverview: Observable<String?> = Observable(nil)
    var outputWindSpeed: Observable<String?> = Observable(nil)
    var outputCloudy: Observable<String?> = Observable(nil)
    var outputPressure: Observable<String?> = Observable(nil)
    var outputHumidity: Observable<String?> = Observable(nil)
    var outputMapCoord: Observable<CLLocationCoordinate2D?> = Observable(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    var outputShowAlert: Observable<Bool> = Observable(false)
 
    init() {
        
        fetchJson()
        
        inputCityID.value = userdefaultsManager.savedID
        inputCityID.bind { id in
            if id != 0 {
                self.outputCityID.value = id
            } else {
                self.outputCityID.value = 1835847
            }
        }
        
        outputCityID.bind { id in
            self.outputCity.value = self.inputCityList.value.filter({ $0.id == id }).first!
            self.outputMapCoord.value = CLLocationCoordinate2D(latitude: self.outputCity.value?.coord.lat ?? 0.0, longitude: self.outputCity.value?.coord.lon ?? 0.0)
            self.callWeather(id: id)
        }
        
        inputCurrentWeather.bind { current in
            self.outputCurrentTemperature.value = current?.weatherDetail.tempStr ?? "--º"
            
            self.outputMaxAndMinTemperature.value = current?.weatherDetail.maxminTempStr ?? "최고: --º | 최저: --º"
            
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
}
