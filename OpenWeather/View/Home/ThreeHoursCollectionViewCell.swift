//
//  ThreeHoursCollectionViewCell.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit
import Kingfisher
import SnapKit

final class ThreeHoursCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 13)
        
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    private let weatherImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    // MARK: - Configurations
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImgView)
        contentView.addSubview(temperatureLabel)
    }
    
    private func configureLayout() {
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(15)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(15)
        }
        
        weatherImgView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.size.equalTo(20)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImgView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
    }
    
    func configureView(subWeather: Weather) {
        dayLabel.text = subWeather.day
        timeLabel.text = subWeather.hour
        weatherImgView.kf.setImage(with: URL(string: subWeather.weatherImageURL))
        temperatureLabel.text = subWeather.weatherDetail.tempStr
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
