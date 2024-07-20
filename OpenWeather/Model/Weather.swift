//
//  Weather.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation

// MARK: - Weather
struct Weather: Decodable {
    let dt: Int
    let weatherDetail: WeatherDetail
    let weatherImage: [WeatherImage]
    let wind: Wind
    let clouds: Clouds
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        
        let date = Date(timeIntervalSince1970: TimeInterval(self.dt))
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        
        let date = Date(timeIntervalSince1970: TimeInterval(self.dt))
        
        if Calendar.current.isDateInToday(date) {
            return "오늘"
        }
        
        return formatter.string(from: date)
    }
    
    var hour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시"
        
        let date = Date(timeIntervalSince1970: TimeInterval(self.dt))
        return formatter.string(from: date)
    }
    
    var weatherImageURL: String {
        return "https://openweathermap.org/img/wn/\(weatherImage.first!.icon)@2x.png"
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case weatherDetail = "main"
        case weatherImage = "weather"
        case wind
        case clouds
    }
}

// MARK: - Coordinate
struct Coord: Codable {
    var lat: Double
    var lon: Double
}

// MARK: - 5D/3H Weather
struct SubWeather: Decodable {
    let result: [Weather]
    let city: OWCity
    
    var rangeOfTomorrow: [Weather] {
        let first = result[result.startIndex]
        let rangeOfTomorrowArray = result.filter({ date in
            let tomorrow = Date(timeIntervalSince1970: TimeInterval(first.dt)).addingTimeInterval(86400).timeIntervalSince1970
            return TimeInterval(date.dt) < tomorrow
        })
        
        return rangeOfTomorrowArray
    }
    
    var fiveDays: [Weather] {
        guard let first = result.first else { return [] }
        let fiveDaysArray = result.filter({ current in
            let isToday = Calendar.current.isDateInToday(Date(timeIntervalSince1970: TimeInterval(first.dt)))
            let difference: Double = isToday ? 4 : 5
            let fiveDays = Date().addingTimeInterval(86400 * difference).timeIntervalSince1970
            
            return TimeInterval(current.dt) <= fiveDays
        }).filter({ dw in
            let day = Date(timeIntervalSince1970: TimeInterval(dw.dt)).timeIntervalSince1970
            let startDay = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(dw.dt))).timeIntervalSince1970
            let endDay = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(dw.dt))).addingTimeInterval(86399).timeIntervalSince1970
            
            return day >= startDay && day <= endDay
        })

        return fiveDaysArray
    }
    
    enum CodingKeys: String, CodingKey {
        case result = "list"
        case city
    }
}

// MARK: - Weather(City)
struct OWCity: Decodable {
    let name: String
    let coord: Coord
}

// MARK: - CurrentWeather
struct WeatherDetail: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    
    var tempStr: String {
        "\(self.temp)" + "º"
    }
}

// MARK: - WeatherImage
struct WeatherImage: Decodable {
    let description: String
    let icon: String
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
}

// MARK: - Clouds
struct Clouds: Decodable {
    var all: Double
}
