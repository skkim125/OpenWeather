//
//  UserDefaultsManager.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import Foundation

final class UserDefaultsManager {
    // MARK: - Singleton Instance
    static let shared = UserDefaultsManager()
    private init() { }
    
    private let userdefaults = UserDefaults.standard
    
    // MARK: - Enum of Key
    enum Key: String {
        case city
    }
    
    // MARK: - Properties
    var savedCity: City {
        get {
            let decoder: JSONDecoder = JSONDecoder()

            guard let data = userdefaults.data(forKey: Key.city.rawValue), let city = try? decoder.decode(City.self, from: data) else {
                return City(id: 0, name: "", country: "", coord: Coord(lat: 0.0, lon: 0.0))
            }
            
            return city
        }
        
        set{
            let encoder: JSONEncoder = JSONEncoder()
            
            if let encodedCity = try? encoder.encode(newValue) {
                userdefaults.set(encodedCity, forKey: Key.city.rawValue)
            } else {
                print("저장 실패")
            }
        }
    }
}
