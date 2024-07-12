//
//  ThreeHoursCollectionViewCell.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit
import Kingfisher
import SnapKit

class ThreeHoursCollectionViewCell: UICollectionViewCell {
    let timeLabel = UILabel()
    let weatherImgView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImgView)
        contentView.addSubview(temperatureLabel)
    }
    
    func configureLayout() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(30)
        }
        
        weatherImgView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(40)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImgView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureView(subWeather: Weather) {
        print(subWeather.hour)
        timeLabel.text = subWeather.hour
        timeLabel.textAlignment = .center
        weatherImgView.kf.setImage(with: URL(string: subWeather.weatherImageURL))
        weatherImgView.contentMode = .scaleAspectFill
        temperatureLabel.text = subWeather.weatherDetail.tempStr
        temperatureLabel.textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
