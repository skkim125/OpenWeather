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
    private var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        checkDeiviceLocationAuthorization()
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        convertCoord()
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
        showTwoButtonAlert(title: "해당 위치의", message: "의 날씨를 확인하시겠습니까?", checkButtonTitle: "저장") {
            print(self.mapView.annotations.first!.coordinate)
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
            serRegionAndAnnotation(center: self.coordinate ?? CLLocationCoordinate2D(latitude: 37.65493, longitude: 127.04761))
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    func serRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        addAnnotation(center: center, title: "선택한 좌표")
    }
    
    func addAnnotation(center: CLLocationCoordinate2D, title: String?) {
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        annotaion.title = title
        
        mapView.addAnnotation(annotaion)
    }
    
    func convertCoord() {
        let tapGestuere = UITapGestureRecognizer(target: self, action: #selector(touchMapView(_:)))
        mapView.addGestureRecognizer(tapGestuere)
    }
    
    @objc func touchMapView(_ view: UITapGestureRecognizer) {
        let location: CGPoint = view.location(in: mapView)
        let mapPoint: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = CLLocationCoordinate2D(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
        annotaion.title = "클릭한 좌표"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotaion)
    }
}

extension SelectLocationMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            self.coordinate = coordinate
            
            serRegionAndAnnotation(center: self.coordinate ?? CLLocationCoordinate2D(latitude: 37.65493, longitude: 127.04761))
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
