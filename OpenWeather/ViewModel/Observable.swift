//
//  Observable.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import Foundation

class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(self.value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T)-> Void) {
//        closure(self.value)
        self.closure = closure
    }
}
