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
    
    typealias CompletionHandler<T> = ((T) -> Void)
    
    func callRequest<T: Decodable>(apiType: OpenWeatherRouter, requestAPIType: T.Type, lat: Double, lon: Double, completionHandler: @escaping CompletionHandler<T>) {
        guard let url = URL(string: OpenWeatherAPI.url + apiType.rawValue) else { return }
        
        let parameters: Parameters = [
            "lat": "\(lat)",
            "lon": "\(lon)",
            "appid": "\(OpenWeatherAPI.key)",
            "units": "metric",
            "lang": "kr"
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
