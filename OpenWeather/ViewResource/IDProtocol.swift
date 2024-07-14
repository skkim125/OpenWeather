//
//  IDProtocol.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit

protocol IDProtocol {
    static var id: String { get }
}

extension UICollectionViewCell: IDProtocol {
    static var id: String {
        String(describing: self)
    }
}

extension UITableViewCell: IDProtocol {
    static var id: String {
        String(describing: self)
    }
}
