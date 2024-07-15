//
//  WeatherDetailView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit
import SnapKit

final class WeatherDetailView: UIView {
    private let titleImageView = UIImageView()
    private let titleLabel = UILabel()
    let divider = DividerLine(color: .gray)
    
    init(image: String, title: String) {
        super.init(frame: .zero)
        
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        configureHierarchy()
        configureLayout()
        configureView(image: image, title: title)
        
        layer.cornerRadius = 12
        clipsToBounds = true
    }

    private func configureHierarchy() {
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(divider)
    }
    
    private func configureLayout() {
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView)
            make.leading.equalTo(titleImageView.snp.trailing).offset(5)
            make.height.equalTo(30)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureView(image: String, title: String) {
        titleImageView.image = UIImage(systemName: image)
        titleImageView.tintColor = .darkGray
        
        titleLabel.text = title
        titleLabel.textColor = .darkGray
        titleLabel.font = .systemFont(ofSize: 14)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
