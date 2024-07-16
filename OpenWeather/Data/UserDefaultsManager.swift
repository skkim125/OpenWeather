//
//  UserDefaultsManager.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() { }
    
    private let userdefaults = UserDefaults.standard
    
    enum Key: String {
        case id
    }
    
    var savedID: Int {
        get {
            return userdefaults.integer(forKey: Key.id.rawValue)
        }
        set {
            userdefaults.setValue(newValue, forKey: Key.id.rawValue)
        }
    }
}
