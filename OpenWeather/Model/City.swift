//
//  City.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import Foundation

class City: Decodable {
    let id: Int
    let name: String
    let country: String
    let coord: Coord
}
