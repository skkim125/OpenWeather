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

class SelectLocationMapView: UIViewController {
    
    private lazy var mapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    private let locationManager = CLLocationManager()
    let viewModel = SelectLocationMapViewModel()
    var moveData: ((City)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        checkDeiviceLocationAuthorization()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        convertCoord()
        bindData()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.title = "위치 선택하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func selectButtonClicked() {
        showTwoButtonAlert(title: "해당 위치의 날씨를 확인하시겠습니까?", message: nil, checkButtonTitle: "저장") { [weak self] in
            guard let self = self else { return }
            self.viewModel.inputselectedLocation.value = true
        }
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
    
    func bindData() {
        viewModel.outputLocation.bind { city in
            self.setRegionLocation(center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
        }
        
        viewModel.inputselectedLocation.bind { isSelected in
            if isSelected {
                self.moveData?(self.viewModel.outputLocation.value)
                self.viewModel.outputSearchWeather.value = ()
                print("선택한 좌표: \(self.viewModel.outputLocation.value)")
                self.dismiss(animated: true)
            }
        }
    }
    
    func checkDeiviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkCurrentLocationAuthorization()
            } else {
                print("디바이스 위치 권한을 허용해주세요")
            }
        }
    }
    
    func checkCurrentLocationAuthorization() {
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
            print("위치 허용")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    func setRegionLocation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        addAnnotation(center: center)
        
    }
    
    func addAnnotation(center: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
                annotation.title = [placemark.locality, placemark.name].compactMap { $0 }.joined(separator: " ")
            }
        }
        
        mapView.addAnnotation(annotation)
    }
    
    func convertCoord() {
        let tapGestuere = UITapGestureRecognizer(target: self, action: #selector(touchMapView(_:)))
        mapView.addGestureRecognizer(tapGestuere)
    }
    
    @objc func touchMapView(_ view: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        let location: CGPoint = view.location(in: mapView)
        let mapPoint: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
                annotation.title = [placemark.locality, placemark.name].compactMap { $0 }.joined(separator: " ")
                self.viewModel.inputLocationName.value = [placemark.locality, placemark.name].compactMap { $0 }.joined(separator: " ")
                
                self.viewModel.inputLocation.value = City(id: -1, name: self.viewModel.inputLocationName.value, country: "", coord: Coord(lat: Double(mapPoint.latitude), lon: Double(mapPoint.longitude)))
            }
        }
        
        mapView.addAnnotation(annotation)
    }
}

extension SelectLocationMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            self.setRegionLocation(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            viewModel.inputLocation.value = City(id: -1, name: "나의 위치", country: "", coord: Coord(lat: coordinate.latitude, lon: coordinate.longitude))
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "iOS 14+")
        checkDeiviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function, "iOS 14-")
    }
}
