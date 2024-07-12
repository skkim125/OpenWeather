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
    private let tableStackView = UIStackView()
    private let cityNameLabel = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let weatherOverviewLabel = UILabel()
    private let dividerLine = UIView()
    private let highestAndLowestTemperatureLabel = UILabel()
    
    private lazy var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: threeHoursViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(ThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: ThreeHoursCollectionViewCell.id)
        cv.backgroundColor = .clear
        return cv
    }()
    
    func threeHoursViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 5
        let sectionSpacing: CGFloat = 5
        layout.sectionInset = .init(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = sectionSpacing
        layout.scrollDirection = .horizontal
        
        let width = UIScreen.main.bounds.width - (cellSpacing * 4 + sectionSpacing)
        layout.itemSize = CGSize(width: width/5, height: width/2.2)
        
        
        return layout
    }
    
    private let threeHoursView = WeatherDetailView(image: "calendar", title: "3시간 간격의 일기예보")
    private let fiveDaysView = WeatherDetailView(image: "calendar", title: "5일 간의 일기예보")
    private let currentLocationView = WeatherDetailView(image: "mappin.and.ellipse", title: "위치")
    
    private let bottomView = UIView()
    private let mapButton = UIButton()
    private let cityListButton = UIButton()
    
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
        
        viewModel.inputSubWeather.bind { _ in
            self.collectionView.reloadData()
        }
    }
    
    func configureHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.addArrangedSubview(currentTemperatureLabel)
        stackView.addArrangedSubview(weatherOverviewLabel)
        stackView.addArrangedSubview(highestAndLowestTemperatureLabel)
        
        scrollView.addSubview(tableStackView)
        tableStackView.addArrangedSubview(threeHoursView)
        tableStackView.addArrangedSubview(fiveDaysView)
        tableStackView.addArrangedSubview(currentLocationView)
        threeHoursView.addSubview(collectionView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(mapButton)
        bottomView.addSubview(cityListButton)
    }
    
    
    func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(scrollView)
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
        
        tableStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(scrollView.self).inset(20)
        }
        
        threeHoursView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(200)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(threeHoursView.divider.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(threeHoursView.snp.horizontalEdges)
            make.bottom.equalTo(threeHoursView.snp.bottom)
        }
        
        fiveDaysView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(300)
        }
        
        currentLocationView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(400)
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
        
        tableStackView.axis = .vertical
        tableStackView.spacing = 20
        
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.inputSubWeather.value?.result.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreeHoursCollectionViewCell.id, for: indexPath) as! ThreeHoursCollectionViewCell
        
        if let value = viewModel.inputSubWeather.value {
            cell.backgroundColor = .clear
            cell.configureView(subWeather: value.result[indexPath.row])
        }
        
        return cell
    }
}
