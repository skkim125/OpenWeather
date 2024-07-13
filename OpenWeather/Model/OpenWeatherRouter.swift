//
//  OpenWeatherRouter.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation
import Alamofire

enum OpenWeatherRouter {
    case currentURL(Double, Double)
    case subWeatherURL(Double, Double)
    
    var apiType: String {
        switch self {
        case .currentURL:
            "weather?"
        case .subWeatherURL:
            "forecast?"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .currentURL(let lat, let lon), .subWeatherURL(let lat, let lon):
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
