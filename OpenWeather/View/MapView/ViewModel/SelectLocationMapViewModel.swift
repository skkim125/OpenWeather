//
//  SelectLocationMapViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/18/24.
//

import UIKit

final class SelectLocationMapViewModel {
    // MARK: - Input ViewModel
    var inputLocation: Observable<City?> = Observable(nil) // input: 처음 입력 받는 값
    var inputselectedLocation: Observable<Bool> = Observable(false)
    var inputLocationName: Observable<String> = Observable("")
    
    // MARK: - Output ViewModel
    var outputLocation: Observable<City> = Observable(City(id: -1, name: "", country: "", coord: Coord(lat: 0.0, lon: 0.0))) // 최종 출력값
    private let outputDefaultsLocation: Observable<City> = Observable(City(id: -1, name: "SeSAC 도봉캠퍼스", country: "", coord: Coord(lat: 37.65493, lon: 127.04761))) // 도봉캠퍼스 값
    
    init() {
        inputLocation.bind { [weak self] city in
            guard let self = self else { return }
            
            if let city = city {
                self.outputLocation.value = city
            } else {
                self.outputLocation.value = self.outputDefaultsLocation.value
            }
        }
    }
}
