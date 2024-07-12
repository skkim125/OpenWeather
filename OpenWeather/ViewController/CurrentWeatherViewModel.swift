//
//  CurrentWeatherViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation

class WeatherViewModel {
    private let owManager = OpenWeatherManager.shared
    
    var inputCoordinate: Observable<(lat: Double, lon: Double)?> = Observable(nil)
    var inputCurrentWeather: Observable<Weather?> = Observable(nil)
    var inputSubWeather: Observable<SubWeather?> = Observable(nil)
    
    
    var outputCityName: Observable<String> = Observable("")
    var outputCurrentTemperature: Observable<String> = Observable("")
    var outputHighestAndLowestTemperature: Observable<String> = Observable("")
    var outputWeatherOverview: Observable<String> = Observable("")
 
    init() {
        
        inputCoordinate.bind { coord in
            self.callWeather(coord: coord ?? (37.5665, 126.9780))
        }
        
        inputSubWeather.bind { sub in
            self.outputCityName.value = sub?.city.name ?? ""
        }
        
        inputCurrentWeather.bind { current in
            self.outputCurrentTemperature.value = "\(current?.weatherDetail.temp ?? 0.0)" + "º"
            
            self.outputHighestAndLowestTemperature.value = "최고: \(current?.weatherDetail.temp_max ?? 0.0) | 최저: \(current?.weatherDetail.temp_min ?? 0.0)º"
            
            self.outputWeatherOverview.value = "\(current?.weatherImage.first?.description ?? "")"
        }
    }
    
    func callWeather(coord: (lat: Double, lon: Double)) {
        self.owManager.callRequest(apiType: .currentURL, requestAPIType: Weather.self, lat: coord.lat, lon: coord.lon) { data in
            self.inputCurrentWeather.value = data
        }
        
        self.owManager.callRequest(apiType: .subWeatherURL, requestAPIType: SubWeather.self, lat: coord.lat, lon: coord.lon) { data in
            self.inputSubWeather.value = data
        }
    }
}
