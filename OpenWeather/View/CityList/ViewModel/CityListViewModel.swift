//
//  CityListViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/16/24.
//

import Foundation

final class CityListViewModel {
    // MARK: Input
    // input 트리거
    var inputTrigger: Observable<Void?> = Observable(nil) // 처음에 실행할 Trigger
    
    // 도시 뷰모델
    var inputCityList: Observable<[City]> = Observable([]) // 도시 리스트
    var inputCity: Observable<City?> = Observable(nil) // 선택한 도시
    
    // MARK: Output
    // 필터링 뷰모델
    var outputfilterList: Observable<[City]> = Observable([]) // 검색 시 필터링 되는 도시 리스트
    
    init() {
        inputTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            self.outputfilterList.value = self.inputCityList.value
        }
    }
    
    deinit {
        print("CityListViewModel deinit")
    }
}
