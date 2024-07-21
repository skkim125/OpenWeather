//
//  SelectLocationMapView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/17/24.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

final class SelectLocationMapView: UIViewController {
    // MARK: - Views
    private let mapView = MKMapView()
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let viewModel = SelectLocationMapViewModel()
    var moveData: ((City)-> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        checkDeviceLocationAuthorization()
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        
        convertCoord()
        bindData()
    }
    
    // MARK: - COnfigurtaions
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.title = "위치 선택하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    private func configureHierarchy() {
        view.addSubview(mapView)
    }
    
    private func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalTo(view)
        }
    }
    
    private func configureView() {
        locationManager.delegate = self
    }
    
    // MARK: - Data Binding Functions
    private func bindData() {
        viewModel.outputLocation.bind { [weak self] city in
            guard let self = self else { return }
            self.setRegionLocation(center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
            self.addAnnotation(center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon), title: city.name)
        }
        
        viewModel.inputselectedLocation.bind { [weak self] isSelected in
            guard let self = self else { return }
            
            if isSelected {
                self.moveData?(self.viewModel.outputLocation.value)
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Functions
    private func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization()
                }
            } else {
                DispatchQueue.main.async {
                    self.showTwoButtonAlert(title: "위치 서비스를 이용할 수 없습니다.", message: "'설정 > 개인정보 보호 및 보안'에서 위치 서비스를 허용주세요.", checkButtonTitle: "설정하러 가기") {
                        if let deviceSetting = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(deviceSetting)
                        }
                    }
                }
            }
        }
    }
    
    private func checkCurrentLocationAuthorization() {
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.showTwoButtonAlert(title: "위치 서비스를 이용할 수 없습니다.", message: "'설정 > 개인정보 보호 및 보안'에서 위치 서비스를 허용주세요.", checkButtonTitle: "설정하러 가기") {
                if let deviceSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(deviceSetting)
                }
            }
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    private func setRegionLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotation(center: CLLocationCoordinate2D, title: String) {
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func convertGeocode(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon), preferredLocale: Locale(identifier: "ko_KR")) { [weak self] placemarks, _ in
            guard let self = self else { return }
            guard let placemark = placemarks?.first else { return }
            self.viewModel.inputLocationName.value = [placemark.locality, placemark.name].compactMap { $0 }.joined(separator: " ")
            self.viewModel.inputLocation.value = City(id: -1, name: self.viewModel.inputLocationName.value, country: "", coord: Coord(lat: lat, lon: lon))
        }
    }
    
    private func convertCoord() {
        let tapGestuere = UITapGestureRecognizer(target: self, action: #selector(touchMapView(_:)))
        mapView.addGestureRecognizer(tapGestuere)
    }
    
    // MARK: - TapGestures Function
    @objc private func touchMapView(_ view: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        let location: CGPoint = view.location(in: mapView)
        let mapPoint: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        convertGeocode(lat: mapPoint.latitude, lon: mapPoint.longitude)
        setRegionLocation(center: mapPoint)
    }
    
    // MARK: - Button Functions
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func selectButtonClicked() {
        showTwoButtonAlert(title: "해당 위치의 날씨를 조회하시겠습니까?", message: nil, checkButtonTitle: "조회하기") { [weak self] in
            guard let self = self else { return }
            self.viewModel.inputselectedLocation.value = true
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension SelectLocationMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            addAnnotation(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), title: "현재 위치")
            viewModel.outputLocation.value = City(id: -1, name: "나의 위치", country: "", coord: Coord(lat: coordinate.latitude, lon: coordinate.longitude))
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkDeviceLocationAuthorization()
    }
}
