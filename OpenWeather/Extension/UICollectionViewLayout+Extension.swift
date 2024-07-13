//
//  UICollectionViewLayout+Extension.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit

extension UICollectionViewLayout {
    static func threeHoursViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        let sectionSpacing: CGFloat = 5
        layout.sectionInset = .init(top: sectionSpacing, left: 0, bottom: sectionSpacing, right: 0)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = sectionSpacing
        layout.scrollDirection = .horizontal
        
        let width = UIScreen.main.bounds.width - (cellSpacing * 5)
        layout.itemSize = CGSize(width: width/6, height: width/2.7)
        
        return layout
    }
}
