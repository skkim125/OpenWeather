//
//  CurrentWeatherView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit

class CurrentWeatherView: UIStackView {
    private let cityNameLabel = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let weatherOverviewLabel = UILabel()
    private let highestAndLowestTemperatureLabel = UILabel()
    
    init(viewModel: WeatherViewModel) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
        bindData(viewModel: viewModel)
    }
    
    func bindData(viewModel: WeatherViewModel) {
        viewModel.outputCityName.bind { city in
            self.cityNameLabel.text = city
        }
        
        viewModel.outputCurrentTemperature.bind { ct in
            self.currentTemperatureLabel.text = ct
        }
        
        viewModel.outputHighestAndLowestTemperature.bind { temp in
            self.highestAndLowestTemperatureLabel.text = temp
        }
        
        viewModel.outputWeatherOverview.bind { overview in
            self.weatherOverviewLabel.text = overview
        }
    }
    
    func configureHierarchy() {
        addArrangedSubview(cityNameLabel)
        addArrangedSubview(currentTemperatureLabel)
        addArrangedSubview(weatherOverviewLabel)
        addArrangedSubview(highestAndLowestTemperatureLabel)
    }
    
    func configureLayout() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(40)
            make.height.equalTo(60)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        currentTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        weatherOverviewLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        highestAndLowestTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func configureView() {
        cityNameLabel.textColor = .black.withAlphaComponent(0.8)
        cityNameLabel.font = .systemFont(ofSize: 50)
        cityNameLabel.textAlignment = .center
        
        currentTemperatureLabel.textColor = .black.withAlphaComponent(0.8)
        currentTemperatureLabel.font = .systemFont(ofSize: 90)
        currentTemperatureLabel.textAlignment = .center
        
        weatherOverviewLabel.textColor = .black.withAlphaComponent(0.8)
        weatherOverviewLabel.font = .systemFont(ofSize: 25)
        weatherOverviewLabel.textAlignment = .center
        
        highestAndLowestTemperatureLabel.textColor = .black.withAlphaComponent(0.8)
        highestAndLowestTemperatureLabel.font = .systemFont(ofSize: 20)
        highestAndLowestTemperatureLabel.textAlignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
