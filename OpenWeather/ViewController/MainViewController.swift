//
//  ViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let cityNameLabel = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let weatherOverviewLabel = UILabel()
    private let highestAndLowestTemperatureLabel = UILabel()
    private let bottomView = UIView()
    private let mapButton = UIButton()
    private let cityListButton = UIButton()
    private let subWeatherCollectionView = UICollectionView()
    
    var viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "gradationImg").cgImage
        view.layer.contents = image
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        bindData()
    }
    
    func bindData() {
        viewModel.inputCoordinate.value = (37.5665, 126.9780)
        
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
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.addArrangedSubview(currentTemperatureLabel)
        stackView.addArrangedSubview(weatherOverviewLabel)
        stackView.addArrangedSubview(highestAndLowestTemperatureLabel)
        
        view.addSubview(bottomView)
        bottomView.addSubview(mapButton)
        bottomView.addSubview(cityListButton)
    }

    
    func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top).offset(40)
            make.height.equalTo(60)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        currentTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        weatherOverviewLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        highestAndLowestTemperatureLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(80)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(bottomView.safeAreaLayoutGuide)
            make.leading.equalTo(bottomView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
        
        cityListButton.snp.makeConstraints { make in
            make.top.equalTo(bottomView.safeAreaLayoutGuide)
            make.trailing.equalTo(bottomView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(40)
        }
    }
    
    func configureView() {
        scrollView.showsVerticalScrollIndicator = true
        
        stackView.axis = .vertical
        
        cityNameLabel.text = viewModel.inputSubWeather.value?.city.name ?? ""
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
        bottomView.backgroundColor = #colorLiteral(red: 0.9494348168, green: 0.9246538877, blue: 0.9809295535, alpha: 1)
        
        mapButton.setImage(UIImage(systemName: "map"), for: .normal)
        mapButton.tintColor = .black
        cityListButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        cityListButton.tintColor = .black
    }

}

