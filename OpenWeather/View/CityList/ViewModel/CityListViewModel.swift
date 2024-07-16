//
//  CityListViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/16/24.
//

import Foundation

class CityListViewModel {
    // MARK: Input
    // input 트리거
    var inputTrigger: Observable<Void?> = Observable(nil)
    
    // 도시 뷰모델
    var inputCityList: Observable<[City]> = Observable([])
    var inputCity: Observable<City?> = Observable(nil)
    
    // MARK: Output
    // 필터링 뷰모델
    var outputfilterList: Observable<[City]> = Observable([])
    
    
    init() {
        inputTrigger.bind { _ in
            self.outputfilterList.value = self.inputCityList.value
        }
    }
}
