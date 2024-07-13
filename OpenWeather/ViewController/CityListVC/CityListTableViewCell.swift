//
//  CityListTableViewCell.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

class CityListTableViewCell: UITableViewCell {
    let hashImageView = UIImageView(image: UIImage(systemName: "number"))
    let cityNameLabel = UILabel()
    let countryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        backgroundColor = .clear
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(hashImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryLabel)
    }
    
    func configureLayout() {
        hashImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.size.equalTo(30)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(5)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(hashImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom)
            make.leading.equalTo(hashImageView.snp.trailing).offset(10)
            make.height.equalTo(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
    }
    
    func configureView(city: City) {
        hashImageView.contentMode = .scaleAspectFit
        hashImageView.tintColor = .white
        
        cityNameLabel.text = city.name
        cityNameLabel.textColor = .white
        cityNameLabel.font = .boldSystemFont(ofSize: 16)
        
        countryLabel.text = city.country
        countryLabel.textColor = .gray
        countryLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
