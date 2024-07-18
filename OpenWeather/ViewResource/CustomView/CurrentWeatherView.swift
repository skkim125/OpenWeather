//
//  CurrentWeatherView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/12/24.
//

import UIKit
import SnapKit

final class CurrentWeatherView: UIStackView {
    private let cityNameLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    private let currentTemperatureLabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 70)
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
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
    }
    
    func bindData(viewModel: MainViewModel) {
        viewModel.intputCity.bind { [weak self] city in
            guard let self = self else { return }
            self.cityNameLabel.text = city?.name ?? ""
        }
        
        viewModel.outputCurrentTemperature.bind { [weak self] ct in
            guard let self = self else { return }
            self.currentTemperatureLabel.text = ct
        }
        
        viewModel.outputMaxAndMinTemperature.bind { [weak self] temp in
            guard let self = self else { return }
            self.max_minTemperatureLabel.text = temp
        }
        
        viewModel.outputWeatherOverview.bind { [weak self] overview in
            guard let self = self else { return }
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
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
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
