//
//  OpenWeatherManager.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation
import Alamofire

final class OpenWeatherManager {
    // MARK: - Singleton Instance
    static let shared = OpenWeatherManager()
    private init() { }
    
    // MARK: - Typealias
    typealias CompletionHandler<T> = ((T?) -> Void)
    
    // MARK: - Functions
    func callRequest<T: Decodable>(api: OpenWeatherRouter, apiType: OpenWeatherRouter.apiType,  requestAPIType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: OpenWeatherAPI.url + apiType.rawValue) else { return }
        
        AF.request(url, parameters: api.parameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
            }
        }
    }
}
