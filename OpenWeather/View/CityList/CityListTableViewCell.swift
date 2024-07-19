//
//  CityListTableViewCell.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

final class CityListTableViewCell: UITableViewCell {
    // MARK: - Views
    private let hashImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "number"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        
        return imageView
    }()
    private let cityNameLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    private let countryLabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    private let checkImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    // MARK: - Configurations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(hashImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(checkImageView)
    }
    
    private func configureLayout() {
        hashImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(5)
            make.size.equalTo(30)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(hashImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.leading.equalTo(hashImageView.snp.trailing).offset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(15)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }
    }
    
    func configureView(city: City, isHidden: Bool) {
        cityNameLabel.text = city.name
        countryLabel.text = city.country
        checkImageView.isHidden = isHidden
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
