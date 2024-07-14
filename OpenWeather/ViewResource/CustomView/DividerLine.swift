//
//  DivderLine.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit
import SnapKit

class DividerLine: UIView {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
