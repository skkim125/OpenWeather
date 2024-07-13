//
//  CurrentWeatherView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit

class CurrentWeatherView: UIStackView {
    private let cityNameLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        
        return label
    }()
    private let currentTemperatureLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 90)
        label.textAlignment = .center
        
        return label
    }()
    private let weatherOverviewLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        
        return label
    }()
    private let max_minTemperatureLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    init(viewModel: WeatherViewModel) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
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
    
    private func configureHierarchy() {
        addArrangedSubview(cityNameLabel)
        addArrangedSubview(currentTemperatureLabel)
        addArrangedSubview(weatherOverviewLabel)
        addArrangedSubview(max_minTemperatureLabel)
    }
    
    private func configureLayout() {
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
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
