//
//  ViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import UIKit
import MapKit
import SnapKit

class MainViewController: UIViewController {
    private let scrollView = UIScrollView()
    private lazy var currentWeatherView = CurrentWeatherView(viewModel: viewModel)
    private let tableStackView = UIStackView()
    
    private let threeHoursView = WeatherDetailView(image: "calendar", title: "3시간 간격의 일기예보")
    private lazy var threeHoursCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.threeHoursViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(ThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: ThreeHoursCollectionViewCell.id)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    private let fiveDaysView = WeatherDetailView(image: "calendar", title: "5일 간의 일기예보")
    private lazy var fiveDaysViewTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(FiveDaysTableViewCell.self, forCellReuseIdentifier: FiveDaysTableViewCell.id)
        tv.backgroundColor = .clear
        tv.rowHeight = 50
        tv.separatorColor = .gray
        tv.separatorInset = .zero
        tv.allowsSelection = false
        
        return tv
    }()
    
    private let currentLocationView = WeatherDetailView(image: "mappin.and.ellipse", title: "위치")
    private let mapView = {
        let map = MKMapView()
        map.isScrollEnabled = false
        map.isRotateEnabled = false
        
        return map
    }()
    
    private let bottomView = MainBottomView()
    
    
    private let userdefaultsManager = UserDefaultsManager.shared
    private var viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "gradationImg").cgImage
        view.layer.contents = image
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        
        bindData()
    }
    
    private func bindData() {
        self.viewModel.outputShowAlert.bind { show in
            if show {
                self.showAlert()
            }
        }
        
        self.viewModel.inputSubWeather.bind { data in
            self.threeHoursCollectionView.reloadData()
            self.fiveDaysViewTableView.reloadData()
        }
        
        self.viewModel.outputMapCoord.bind { coord in
            self.mapView.region = .init(center: coord ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), latitudinalMeters: 20000, longitudinalMeters: 20000)
            
            let marker = MKPointAnnotation()
            marker.coordinate = coord ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            
            marker.title = self.viewModel.outputCity.value?.name ?? ""
            self.mapView.addAnnotation(marker)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(currentWeatherView)
        scrollView.addSubview(tableStackView)
        
        tableStackView.addArrangedSubview(threeHoursView)
        threeHoursView.addSubview(threeHoursCollectionView)
        
        tableStackView.addArrangedSubview(fiveDaysView)
        fiveDaysView.addSubview(fiveDaysViewTableView)
        
        tableStackView.addArrangedSubview(currentLocationView)
        currentLocationView.addSubview(mapView)
        
        view.addSubview(bottomView)
    }
    
    
    private func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentWeatherView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
        }
        
        tableStackView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(scrollView.self).inset(20)
        }
        
        threeHoursView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(160)
        }
        
        threeHoursCollectionView.snp.makeConstraints { make in
            make.top.equalTo(threeHoursView.divider.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(threeHoursView.snp.horizontalEdges).inset(20)
            make.bottom.equalTo(threeHoursView.snp.bottom).inset(10)
        }
        
        fiveDaysView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(320)
        }
        
        fiveDaysViewTableView.snp.makeConstraints { make in
            make.top.equalTo(fiveDaysView.divider.snp.bottom)
            make.horizontalEdges.equalTo(fiveDaysView.snp.horizontalEdges).inset(20)
            make.bottom.equalTo(fiveDaysView.snp.bottom).inset(10)
        }
        
        currentLocationView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(400)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(currentLocationView.divider.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(currentLocationView).inset(20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(80)
        }
    }
    
    private func configureView() {
        scrollView.showsVerticalScrollIndicator = true
        
        currentWeatherView.axis = .vertical
        
        tableStackView.axis = .vertical
        tableStackView.spacing = 20
        
        bottomView.backgroundColor = #colorLiteral(red: 0.9494348168, green: 0.9246538877, blue: 0.9809295535, alpha: 1)
        
        bottomView.cityListButton.isUserInteractionEnabled = true
        bottomView.cityListButton.addTarget(self, action: #selector(cityListButtonClicked), for: .touchUpInside)
    }
    
    @objc private func cityListButtonClicked() {
        let vc = CityListViewController()
        
        vc.viewModel = self.viewModel
        vc.moveData = { city, vm in
            self.viewModel = vm
            self.viewModel.inputCityID.value = city.id
            self.userdefaultsManager.saveID = city.id
            self.bindData()
            self.threeHoursCollectionView.reloadData()
            self.fiveDaysViewTableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "네트워크 연결 실패", message: "잠시 후 다시 시도해주세요", preferredStyle: .alert)
        let back = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(back)
        
        present(alert, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.inputSubWeather.value?.rangeOfTomorrow.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreeHoursCollectionViewCell.id, for: indexPath) as? ThreeHoursCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = viewModel.inputSubWeather.value {
            cell.backgroundColor = .clear
            cell.configureView(subWeather: data.result[indexPath.row])
        }
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.inputSubWeather.value?.fiveDays.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysTableViewCell.id, for: indexPath) as? FiveDaysTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.inputSubWeather.value {
            cell.configureView(weather: data.fiveDays[indexPath.row])
        }
        
        return cell
    }
}
