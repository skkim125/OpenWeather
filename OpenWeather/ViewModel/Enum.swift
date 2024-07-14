//
//  Enum.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import Foundation

//var outputWindSpeed: Observable<String?> = Observable(nil)
//var outputCloudy: Observable<String?> = Observable(nil)
//var outputPressure: Observable<String?> = Observable(nil)
//var outputHumidity: Observable<String?> = Observable(nil)

enum WeatherDetailType: String, CaseIterable {
    case windSpeed = "풍속"
    case cloudy = "구름"
    case pressure = "기압"
    case humidity = "습도"
    
    var image: String {
        switch self {
        case .windSpeed:
            return "wind"
        case .cloudy:
            return "cloud.fill"
        case .pressure:
            return "thermometer.medium"
        case .humidity:
            return "humidity"
        }
    }
}
