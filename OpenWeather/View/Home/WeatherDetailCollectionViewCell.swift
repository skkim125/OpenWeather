//
//  WeatherDetailCollectionViewCell.swift
//  OpenWeather
//
//  Created by 김상규 on 7/14/24.
//

import UIKit
import SnapKit

final class WeatherDetailCollectionViewCell: UICollectionViewCell {
    private let detailImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    private let detailLabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
    }()
    private let detailValueLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(detailImageView)
        contentView.addSubview(detailLabel)
        contentView.addSubview(detailValueLabel)
    }
    
    private func configureLayout() {
        detailImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(detailImageView)
            make.leading.equalTo(detailImageView.snp.trailing).offset(10)
            make.height.equalTo(25)
        }
        
        detailValueLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(40)
        }
    }
    
    func configureView(type: WeatherDetailType, viewModel: MainViewModel) {
        detailImageView.image = UIImage(systemName: type.image)
        detailLabel.text = type.rawValue
        detailValueLabel.text = setWeatherDetailValue(type: type, viewModel: viewModel)
    }
    
    private func setWeatherDetailValue(type: WeatherDetailType, viewModel: MainViewModel) -> String {
        switch type {
        case .windSpeed:
            return viewModel.outputWindSpeed.value ?? "--m/s"
        case .cloudy:
            return viewModel.outputCloudy.value ?? "--%"
        case .pressure:
            return viewModel.outputPressure.value ?? "-- hpa"
        case .humidity:
            return viewModel.outputHumidity.value ?? "--%"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
