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
    
    var inputCityID: Observable<Int?> = Observable(nil) // 입력 받는 id
    var inputCityList: Observable<[City]> = Observable([])
    var inputCurrentWeather: Observable<Weather?> = Observable(nil)
    var inputSubWeather: Observable<SubWeather?> = Observable(nil)
    
    var outputCityID: Observable<Int> = Observable(0) // 호출 id
    var outputCity: Observable<City?> = Observable(nil)
    var outputCurrentTemperature: Observable<String> = Observable("")
    var outputMaxAndMinTemperature: Observable<String> = Observable("")
    var outputWeatherOverview: Observable<String> = Observable("")
    var outputMapCoord: Observable<CLLocationCoordinate2D> = Observable(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
 
    init() {
        
        fetchJson()
        
        if let id = inputCityID.value {
            outputCityID.value = id
        } else {
            outputCityID.value = 1835847
        }
        
        print(outputCityID.value)
        
        outputCityID.bind { id in
            self.outputCity.value = self.inputCityList.value.filter({ $0.id == id }).first!
            self.callWeather(id: id)
        }
        
        inputCurrentWeather.bind { current in
            self.outputCurrentTemperature.value = current?.weatherDetail.tempStr ?? ""
            
            self.outputMaxAndMinTemperature.value = current?.weatherDetail.maxminTempStr ?? ""
            
            self.outputWeatherOverview.value = "\(current?.weatherImage.first?.description ?? "")"
        }
    }
    
    func callWeather(id: Int) {
        self.owManager.callRequest(api: .currentURL(id), requestAPIType: Weather.self) { data in
            self.inputCurrentWeather.value = data
        }
        
        self.owManager.callRequest(api: .subWeatherURL(id), requestAPIType: SubWeather.self) { data in
            self.inputSubWeather.value = data
            self.outputMapCoord.value = CLLocationCoordinate2D(latitude: data.city.coord.lat, longitude: data.city.coord.lon)
        }
    }
    
    func fetchJson() {
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
    
    func pickCity(city: City) {
        inputCityID.value = city.id
    }
}
