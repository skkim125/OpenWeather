//
//  Weather.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let weatherDetail: WeatherDetail
    let weatherImage: [WeatherImage]
    let wind: Wind
    let clouds: Clouds
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case weatherDetail = "main"
        case weatherImage = "weather"
        case wind = "wind"
        case clouds = "clouds"
    }
}

struct SubWeather: Decodable {
    let result: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case result = "list"
    }
}

struct WeatherDetail: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct WeatherImage: Decodable {
    let description: String
    let icon: String
}

struct Wind: Decodable {
    let speed: Double
}

struct Clouds: Decodable {
    var all: Double
}
