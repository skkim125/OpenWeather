//
//  OpenWeatherRouter.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation
import Alamofire

enum OpenWeatherRouter {
    case currentURL(Int)
    case subWeatherURL(Int)
    case locationURL(Double, Double)
    
    enum apiType: String {
        case current = "weather?"
        case subWeather = "forecast?"
    }
    
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
}
