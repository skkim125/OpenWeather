//
//  OpenWeatherManager.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation
import Alamofire

class OpenWeatherManager {
    static let shared = OpenWeatherManager()
    private init() { }
    
    func callRequest<T: Decodable>(requestAPIType: T.Type, lat: Double, lon: Double) {
        guard let url = URL(string: OpenWeatherAPI.currentURL) else { return }
        
        let parameters: Parameters = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "appid": "\(OpenWeatherAPI.key)",
            "exclude": "current",
            "units": "metric",
            "lang": "kr"
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print("\(data)")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
