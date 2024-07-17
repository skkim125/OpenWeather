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
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    private let dayWeatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()
    
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
        dayWeatherImageView.kf.setImage(with: URL(string: maxWeather.weatherImageURL))
        minTempLabel.text = "최저" + String.transTempStr(minWeather.weatherDetail.temp_min)
        maxTempLabel.text = "최고" + String.transTempStr(maxWeather.weatherDetail.temp_max)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
