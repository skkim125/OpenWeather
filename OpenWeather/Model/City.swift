//
//  City.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import Foundation

struct City: Codable {
    let id: Int
    var name: String
    let country: String
    var coord: Coord
}
