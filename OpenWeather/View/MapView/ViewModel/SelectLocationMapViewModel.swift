//
//  SelectLocationMapViewModel.swift
//  OpenWeather
//
//  Created by 김상규 on 7/18/24.
//

import UIKit

final class SelectLocationMapViewModel {
    // MARK: - Input ViewModel
    var inputLocation: Observable<City?> = Observable(nil)
    var inputselectedLocation: Observable<Bool> = Observable(false)
    var inputLocationName: Observable<String> = Observable("")
    
    // MARK: - Output ViewModel
    var outputLocation: Observable<City> = Observable(City(id: -1, name: "", country: "", coord: Coord(lat: 0.0, lon: 0.0)))
    var outputSearchWeather: Observable<Void?> = Observable(nil)
    let outputDefaultsLocation: Observable<City> = Observable(City(id: -1, name: "SeSAC 도봉캠퍼스", country: "", coord: Coord(lat: 37.65493, lon: 127.04761)))
    
    init() {
        inputLocation.bind { city in
            if let city = city {
                self.outputLocation.value = city
            } else {
                self.outputLocation.value = self.outputDefaultsLocation.value
            }
        }
    }
}
