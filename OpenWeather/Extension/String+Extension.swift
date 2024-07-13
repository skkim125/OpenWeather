//
//  String+Extension.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import Foundation

extension String {
    static func transTempStr(_ temp: Double) -> String {
        let intTemp = Int(temp)
        
        return String(intTemp) + "º"
    }
}
