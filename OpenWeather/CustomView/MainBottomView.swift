//
//  MainBottomView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

class MainBottomView: UIView {
    private let mapButton = UIButton()
    let cityListButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(mapButton)
        addSubview(cityListButton)
    }
    
    private func configureLayout() {
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        
        cityListButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
    }
    
    private func configureView() {
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.tintColor = .black
        
        cityListButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        cityListButton.tintColor = .black
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
