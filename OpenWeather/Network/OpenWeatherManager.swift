//
//  OpenWeatherManager.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation
import Alamofire

final class OpenWeatherManager {
    static let shared = OpenWeatherManager()
    private init() { }
    
    typealias CompletionHandler<T> = ((T?) -> Void)
    
    func callRequest<T: Decodable>(api: OpenWeatherRouter, requestAPIType: T.Type, completionHandler: @escaping CompletionHandler<T>) {
        guard let url = URL(string: OpenWeatherAPI.url + api.apiType) else { return }
        
        AF.request(url, parameters: api.parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
}
