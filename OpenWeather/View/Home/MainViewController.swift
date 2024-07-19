//
//  ViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/11/24.
//

import UIKit
import MapKit
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - Views
    private let scrollView = UIScrollView()
    private lazy var currentWeatherView = CurrentWeatherView()
    private let tableStackView = UIStackView()
    
    private let threeHoursView = WeatherDetailView(image: "calendar", title: "3시간 간격의 일기예보")
    private lazy var threeHoursCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    private lazy var weatherDeatailCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 10, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(WeatherDetailCollectionViewCell.self, forCellWithReuseIdentifier: WeatherDetailCollectionViewCell.id)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.layer.cornerRadius = 12
        
        return cv
    }()
    private let mainBottomView = MainBottomView()
    
    // MARK: - Properties
    private let userdefaultsManager = UserDefaultsManager.shared
    private var viewModel = MainViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configurations
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
        
        tableStackView.addArrangedSubview(weatherDeatailCollectionView)
        view.addSubview(mainBottomView)
    }
    
    private func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        currentWeatherView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.horizontalEdges.equalTo(scrollView).inset(20)
            make.centerX.equalTo(scrollView)
        }
        
        tableStackView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(scrollView.self).inset(20)
        }
        
        threeHoursView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(180)
        }
        
        threeHoursCollectionView.snp.makeConstraints { make in
            make.top.equalTo(threeHoursView.divider.snp.bottom).offset(5)
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
        
        weatherDeatailCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(380)
        }
        
        currentLocationView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(tableStackView)
            make.height.equalTo(400)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(currentLocationView.divider.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(currentLocationView).inset(20)
        }
        
        mainBottomView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.equalTo(view)
            make.height.equalTo(60)
            make.horizontalEdges.equalTo(view)
        }
    }
    
    private func configureView() {
        let image = #imageLiteral(resourceName: "gradationImg").cgImage
        view.layer.contents = image
        
        scrollView.showsVerticalScrollIndicator = true
        
        currentWeatherView.axis = .vertical
        
        tableStackView.axis = .vertical
        tableStackView.spacing = 20
        
        mainBottomView.mapButton.addTarget(self, action: #selector(mapbuttonclicked), for: .touchUpInside)
        mainBottomView.cityListButton.addTarget(self, action: #selector(cityListButtonClicked), for: .touchUpInside)
        mainBottomView.backgroundColor = #colorLiteral(red: 0.9494348168, green: 0.9246538877, blue: 0.9809295535, alpha: 1)
    }
    
    // MARK: - DataBinding Function
    private func bindData() {
        
        viewModel.outputNetworkingComplete.bind { [weak self] isComplete in
            guard let self = self else { return }
            if isComplete {
                self.currentWeatherView.bindData(viewModel: viewModel)
                self.threeHoursCollectionView.reloadData()
                self.weatherDeatailCollectionView.reloadData()
                self.fiveDaysViewTableView.reloadData()
                self.viewModel.outputNetworkingComplete.value = false
            }
        }
        
        viewModel.outputMapCoord.bind { [weak self] coord in
            guard let self = self else { return }
            self.mapView.region = .init(center: CLLocationCoordinate2D(latitude: coord.0 ?? 0.0, longitude: coord.1 ?? 0.0), latitudinalMeters: 20000, longitudinalMeters: 20000)
            
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: coord.0 ?? 0.0, longitude: coord.1 ?? 0.0)
            marker.title = self.viewModel.inputCity.value?.name ?? ""
            self.mapView.addAnnotation(marker)
        }
        
        viewModel.outputShowAlert.bind { [weak self] show in
            guard let self = self else { return }
            if show {
                self.showOneButtonAlert(title: "네트워크 연결 실패", message: "잠시 후 다시 시도해주세요")
            }
        }
    }
    
    // MARK: - Button Functions
    @objc func mapbuttonclicked() {
        let vc = SelectLocationMapView()
        vc.moveData = { [weak self] city in
            guard let self = self else { return }
            self.viewModel.inputCity.value = city
            self.userdefaultsManager.savedCity = city
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            print("self.userdefaultsManager.savedCity = \(self.userdefaultsManager.savedCity)")
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
    @objc private func cityListButtonClicked() {

        let vc = CityListViewController()
        vc.viewModel.inputCityList.value = viewModel.inputCityList.value
        vc.viewModel.inputCity.value = viewModel.inputCity.value
        vc.moveData = { [weak self] city in
            guard let self = self else { return }
            self.viewModel.inputCity.value = city
            self.userdefaultsManager.savedCity = city
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == threeHoursCollectionView {
            let width = collectionView.bounds.width - 20
            return CGSize(width: width/5, height: width/2.3)
        } else {
            let width = collectionView.bounds.width - 20
            return CGSize(width: width/2, height: width/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == threeHoursCollectionView {
            return viewModel.outputSubWeather.value?.rangeOfTomorrow.count ?? 0
        } else {
            return OpenWeatherRouter.WeatherDetailType.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == threeHoursCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreeHoursCollectionViewCell.id, for: indexPath) as? ThreeHoursCollectionViewCell else { return UICollectionViewCell() }
            
            if let data = viewModel.outputSubWeather.value {
                cell.backgroundColor = .clear
                cell.configureView(subWeather: data.result[indexPath.row])
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDetailCollectionViewCell.id, for: indexPath) as? WeatherDetailCollectionViewCell else { return UICollectionViewCell() }
            
            let data = OpenWeatherRouter.WeatherDetailType.allCases[indexPath.row]
            cell.configureView(type: data, viewModel: viewModel)
            cell.backgroundColor = .lightGray.withAlphaComponent(0.3)
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            
            return cell

        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputFiveDays.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysTableViewCell.id, for: indexPath) as? FiveDaysTableViewCell else { return UITableViewCell() }
        let day = viewModel.outputFiveDays.value[indexPath.row]
        if let data = viewModel.outputMinMaxTempOfDay.value[day] {
            cell.configureView(minWeather: data.0, maxWeather: data.1)
        }
        return cell
    }
}
