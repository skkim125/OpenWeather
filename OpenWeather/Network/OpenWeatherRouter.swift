//
//  OpenWeatherRouter.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation
import Alamofire

enum OpenWeatherRouter {
    // MARK: Cases
    case currentURL(Int)
    case subWeatherURL(Int)
    case locationURL(Double, Double)
    
    // MARK: - apiType Enum
    enum apiType: String {
        case current = "weather?"
        case subWeather = "forecast?"
    }
    
    // MARK: Properties
    var parameters: Parameters {
        switch self {
        case .currentURL(let id), .subWeatherURL(let id):
            return [
                "id": "\(id)",
                "appid": "\(OpenWeatherAPI.key)",
                "units": "metric",
                "lang": "kr"
            ]
            
        case .locationURL(let lat, let lon):
            return [
                "lat": "\(lat)",
                "lon": "\(lon)",
                "appid": "\(OpenWeatherAPI.key)",
                "units": "metric",
                "lang": "kr"
            ]
        }
    }
    
    // MARK: - WeatherDetailType Enum
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
}
