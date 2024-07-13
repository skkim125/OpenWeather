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
    var outputMaxAndMinTemperature: Observable<String> = Observable("")
    var outputWeatherOverview: Observable<String> = Observable("")
 
    init() {
        
        inputCoordinate.bind { coord in
            self.callWeather(coord: coord ?? (37.5665, 126.9780))
        }
        
        inputCurrentWeather.bind { current in
            self.outputCurrentTemperature.value = current?.weatherDetail.tempStr ?? ""
            
            self.outputMaxAndMinTemperature.value = current?.weatherDetail.maxminTempStr ?? ""
            
            self.outputWeatherOverview.value = "\(current?.weatherImage.first?.description ?? "")"
        }
    }
    
    func callWeather(coord: (lat: Double, lon: Double)) {
        self.owManager.callRequest(api: .currentURL(coord.lat, coord.lon), requestAPIType: Weather.self) { data in
            self.inputCurrentWeather.value = data
        }
        
        self.owManager.callRequest(api: .subWeatherURL(coord.lat, coord.lon), requestAPIType: SubWeather.self) { data in
            self.inputSubWeather.value = data
            self.outputCityName.value = data.city.name
            
            //            for i in self.inputSubWeather.value!.fiveDays {
            //                print(i.dayOfWeek)
            //            }
            // print(self.inputSubWeather.value?.fiveDays[0].dayOfWeek)
        }
    }
}
