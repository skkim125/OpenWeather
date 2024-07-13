//
//  Weather.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import Foundation

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
        case dt = "dt"
        case weatherDetail = "main"
        case weatherImage = "weather"
        case wind = "wind"
        case clouds = "clouds"
    }
}

struct SubWeather: Decodable {
    let result: [Weather]
    let city: City
    
    var rangeOfTomorrow: [Weather] {
        let first = result[result.startIndex]
        let rangeOfTomorrowArray = result.filter({ date in
            let tomorrow = Date(timeIntervalSince1970: TimeInterval(first.dt)).addingTimeInterval(86400).timeIntervalSince1970
            return TimeInterval(date.dt) < tomorrow
        })
        
        return rangeOfTomorrowArray
    }
    
    var fiveDays: [Weather] {
        let fiveDaysArray = result.filter({ date in
            let fiveDays = Date().addingTimeInterval(86400 * 5).timeIntervalSince1970
            return TimeInterval(date.dt) <= fiveDays
        }).filter({ date in
            Date(timeIntervalSince1970: TimeInterval(date.dt)).timeIntervalSince1970 == Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(date.dt))).timeIntervalSince1970
        })
        
        return fiveDaysArray
    }
    
    enum CodingKeys: String, CodingKey {
        case result = "list"
        case city = "city"
    }
}

struct City: Decodable {
    let name: String
}

struct WeatherDetail: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
    
    var tempStr: String {
        "\(self.temp)" + "º"
    }
    
    var maxminTempStr: String {
        "최고: \(temp_max)º | 최저: \(temp_min)º"
    }
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
