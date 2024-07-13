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
    private let max_minTemperatureLabel = UILabel()
    
    init(viewModel: WeatherViewModel) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
        bindData(viewModel: viewModel)
        
    }
    
    func bindData(viewModel: WeatherViewModel) {
        viewModel.outputCity.bind { city in
            self.cityNameLabel.text = city?.name ?? ""
        }
        
        viewModel.outputCurrentTemperature.bind { ct in
            self.currentTemperatureLabel.text = ct
        }
        
        viewModel.outputMaxAndMinTemperature.bind { temp in
            self.max_minTemperatureLabel.text = temp
        }
        
        viewModel.outputWeatherOverview.bind { overview in
            self.weatherOverviewLabel.text = overview
        }
    }
    
    func configureHierarchy() {
        addArrangedSubview(cityNameLabel)
        addArrangedSubview(currentTemperatureLabel)
        addArrangedSubview(weatherOverviewLabel)
        addArrangedSubview(max_minTemperatureLabel)
    }
    
    func configureLayout() {
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
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
        
        max_minTemperatureLabel.snp.makeConstraints { make in
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
        
        max_minTemperatureLabel.textColor = .black.withAlphaComponent(0.8)
        max_minTemperatureLabel.font = .systemFont(ofSize: 20)
        max_minTemperatureLabel.textAlignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
