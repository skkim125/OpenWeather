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
        let cv = UICollectionView(frame: .zero, collectionViewLayout: threeHoursViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(ThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: ThreeHoursCollectionViewCell.id)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    func threeHoursViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        let sectionSpacing: CGFloat = 5
        layout.sectionInset = .init(top: sectionSpacing, left: 0, bottom: sectionSpacing, right: 0)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = sectionSpacing
        layout.scrollDirection = .horizontal
        
        let width = UIScreen.main.bounds.width - (cellSpacing * 5)
        layout.itemSize = CGSize(width: width/6, height: width/2.7)
        
        return layout
    }
    
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
        self.viewModel.inputSubWeather.bind { _ in
            self.threeHoursCollectionView.reloadData()
            self.fiveDaysViewTableView.reloadData()
        }
        
        self.viewModel.outputMapCoord.bind { coord in
            self.mapView.region = .init(center: coord, latitudinalMeters: 20000, longitudinalMeters: 20000)
            
            let marker = MKPointAnnotation()
            marker.coordinate = coord
            marker.title = self.viewModel.outputCity.value?.name ?? ""
            self.mapView.addAnnotation(marker)
        }
    }
    
    func configureHierarchy() {
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
    
    
    func configureLayout() {
        
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
    
    func configureView() {
        scrollView.showsVerticalScrollIndicator = true
        
        currentWeatherView.axis = .vertical
        
        tableStackView.axis = .vertical
        tableStackView.spacing = 20
        
        bottomView.backgroundColor = #colorLiteral(red: 0.9494348168, green: 0.9246538877, blue: 0.9809295535, alpha: 1)
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
