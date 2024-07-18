//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation

final class MainViewModel {
    private let owManager = OpenWeatherManager.shared
    private let userdefaultsManager = UserDefaultsManager.shared
    
    // MARK: Input
    // 도시 뷰모델
    var inputCityID: Observable<Int> = Observable(0)
    var intputCity: Observable<City?> = Observable(nil)
    var inputCityList: Observable<[City]> = Observable([])
    
    // MARK: Output
    // OpenWeatherAPI 통신 관련 뷰모델
    var outputCurrentWeather: Observable<Weather?> = Observable(nil) // 출력할 현재 날씨
    var outputSubWeather: Observable<SubWeather?> = Observable(nil) // 출력할 서브 날씨
    var outputNetworkingComplete: Observable<Bool> = Observable(false) // 네트워크 비동기 통신 완료 시점
    
    // threeHoursView 표시 뷰모델
    var outputCurrentTemperature: Observable<String> = Observable("") // 현재 위치의 온도
    var outputMaxAndMinTemperature: Observable<String> = Observable("") // 현재 위치의 최고/최저 온도
    var outputWeatherOverview: Observable<String?> = Observable(nil) // 현재 위치의 날씨 설명
    
    // fiveDaysView 표시 뷰모델
    var outputFiveDays: Observable<[String]> = Observable([]) // 5일 배열
    var outputMinMaxTempOfDay: Observable<[String: (Weather, Weather)]> = Observable([:]) // 5일간의 최고/최저 온도 딕셔너리
    
    // weatherDeatailCollectionView 표시 뷰모델
    var outputWindSpeed: Observable<String?> = Observable(nil) // 현재 위치의 풍속
    var outputCloudy: Observable<String?> = Observable(nil) // 현재 위치의 구름 비율
    var outputPressure: Observable<String?> = Observable(nil) // 현재 위치의 기압
    var outputHumidity: Observable<String?> = Observable(nil) // 현재 위치의 습도
    
    // 기타
    var outputMapCoord: Observable<(Double?, Double?)> = Observable((nil, nil)) // 맵뷰에 표시할 위/경도
    var outputShowAlert: Observable<Bool> = Observable(false) // 네트워크 연결에 대한 알럿 표시
    
    init() {
        print("mainviewmodel init")
        transform()
    }
    
    deinit {
        print("mainviewmodel deinit")
    }
    
    func transform() {
        fetchJson()
        setInputCityID()
        
        inputCityID.bind { [weak self] id in
            guard let self = self else { return }
            guard let city = self.inputCityList.value.filter({ $0.id == id }).first else { return }
            self.intputCity.value = city
            self.outputMapCoord.value = (city.coord.lat, city.coord.lon)
            self.callWeather()
        }
        
        outputCurrentWeather.bind { [weak self] current in
            guard let self = self else { return }
            self.outputCurrentTemperature.value = current?.weatherDetail.tempStr ?? "--º"
            
            self.outputWeatherOverview.value = current?.weatherImage.first?.description ?? "--"
            
            self.outputWindSpeed.value = String(format: "%.2f", current?.wind.speed ?? 0.0) + "m/s"
            
            self.outputCloudy.value = "\(Int(current?.clouds.all ?? 0.0))" + "%"
            self.outputPressure.value = NumberFormatter.localizedString(from: (current?.weatherDetail.pressure ?? 0) as NSNumber, number: .decimal) + "hpa"
            self.outputHumidity.value = NumberFormatter.localizedString(from: (current?.weatherDetail.humidity ?? 0) as NSNumber, number: .decimal) + "%"
        }
    }
    
    private func fetchJson() {
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json"), let jsonStr = try? String(contentsOfFile: path) else {
            return
        }
        
        let decoder = JSONDecoder()
        let data = jsonStr.data(using: .utf8)
        
        if let data = data,
           let cities = try? decoder.decode([City].self, from: data) {
            inputCityList.value = cities
        }
    }
    
    private func setInputCityID() {
        if userdefaultsManager.savedID != 0 {
            inputCityID.value = userdefaultsManager.savedID
            
        } else {
            inputCityID.value = 1835847
        }
    }
    
    private func callWeather() {
        let group = DispatchGroup()
        
        group.enter()
        owManager.callRequest(api: .currentURL(inputCityID.value), apiType: .current, requestAPIType: Weather.self) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.outputCurrentWeather.value = data
                self.outputShowAlert.value = false
            case .failure(let error):
                self.outputShowAlert.value = true
            }
            group.leave()
        }
        
        group.enter()
        owManager.callRequest(api: .subWeatherURL(inputCityID.value), apiType: .subWeather, requestAPIType: SubWeather.self) { [weak self] response in
            
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.outputSubWeather.value = data
                self.outputMapCoord.value = (data.city.coord.lat, data.city.coord.lon)
                self.outputShowAlert.value = false
                self.addMinMaxTemp(data: data)
                self.outputFiveDays.value = self.mappingFiveDays(fiveDays: data.fiveDays)
                if let day = self.outputCurrentWeather.value?.day {
                    self.setOutputMaxAndMinTemperature(day: day)
                }
            case .failure(let error):
                print(error)
                self.outputShowAlert.value = true
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.outputNetworkingComplete.value = true
        }
    }
    
    private func addMinMaxTemp(data: SubWeather) {
        for weather in data.fiveDays {
            let day = weather.day
            
            let tempMin = weather.weatherDetail.temp_min
            let tempMax = weather.weatherDetail.temp_max
            if let value = outputMinMaxTempOfDay.value[day] {
                let minWeather = (tempMin < value.0.weatherDetail.temp_min) ? weather : value.0
                let maxWeather = (tempMax > value.1.weatherDetail.temp_max) ? weather : value.1
                
                outputMinMaxTempOfDay.value[day] = (minWeather, maxWeather)
            } else {
                outputMinMaxTempOfDay.value[day] = (weather, weather)
            }
        }
    }
    
    private func setOutputMaxAndMinTemperature(day: String) {
        if let current = outputCurrentWeather.value {
            let cwMinTemp: String? = String(outputMinMaxTempOfDay.value[day]?.0.weatherDetail.temp_min ?? current.weatherDetail.temp_min)
            let cwMaxTemp: String? = String(outputMinMaxTempOfDay.value[day]?.1.weatherDetail.temp_max ?? current.weatherDetail.temp_max)
            
            outputMaxAndMinTemperature.value = "최고: \(cwMaxTemp ?? "--")º | 최저: \(cwMinTemp ?? "--")º"
        }
    }
    
    private func mappingFiveDays(fiveDays: [Weather]) -> [String] {
        let mapping = fiveDays.map({ $0.day })
        return Array(Set(mapping)).sorted(by: { $0 < $1 })
    }
}
