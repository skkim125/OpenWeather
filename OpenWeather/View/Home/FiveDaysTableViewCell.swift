//
//  FiveDaysTableView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import Kingfisher
import SnapKit

final class FiveDaysTableViewCell: UITableViewCell {
    private let daysLabel = UILabel()
    private let dayWeatherImageView = UIImageView()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(daysLabel)
        contentView.addSubview(dayWeatherImageView)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
    }
    
    private func configureLayout() {
        daysLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo((contentView))
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo((contentView))
            make.centerX.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        dayWeatherImageView.snp.makeConstraints { make in
            make.centerY.equalTo((contentView))
            make.leading.equalTo(daysLabel.snp.trailing)
            make.trailing.equalTo(minTempLabel.snp.leading).inset(20)
            make.height.equalTo(50)
        }
    }
    
    func configureView(minWeather: Weather, maxWeather: Weather) {
        daysLabel.text = minWeather.dayOfWeek
        daysLabel.font = .boldSystemFont(ofSize: 20)
        
        dayWeatherImageView.kf.setImage(with: URL(string: maxWeather.weatherImageURL))
        dayWeatherImageView.contentMode = .scaleAspectFit
        
        minTempLabel.text = "최저" + String.transTempStr(minWeather.weatherDetail.temp_min)
        minTempLabel.textColor = .darkGray
        minTempLabel.font = .boldSystemFont(ofSize: 20)
        minTempLabel.textAlignment = .center
        
        
        maxTempLabel.text = "최고" + String.transTempStr(maxWeather.weatherDetail.temp_max)
        maxTempLabel.font = .boldSystemFont(ofSize: 20)
        maxTempLabel.textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
