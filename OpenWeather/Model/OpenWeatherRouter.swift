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
        case .currentURL(let id), .subWeatherURL(let id):
            return [
                "id": "\(id)",
                "appid": "\(OpenWeatherAPI.key)",
                "units": "metric",
                "lang": "kr"
            ]
        }
    }
}
