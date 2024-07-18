//
//  MainBottomView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

final class MainBottomView: UIView {
    let mapButton = UIButton()
    let cityListButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func configureHierarchy() {
        addSubview(mapButton)
        addSubview(cityListButton)
    }
    
    private func configureLayout() {
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(50)
        }
        
        cityListButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.size.equalTo(50)
        }
    }
    
    private func configureView() {
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.imageView?.contentMode = .scaleAspectFit
        mapButton.tintColor = .black
        
        cityListButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        cityListButton.imageView?.contentMode = .scaleAspectFit
        cityListButton.tintColor = .black
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
