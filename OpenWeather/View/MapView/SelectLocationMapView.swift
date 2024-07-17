//
//  SelectLocationMapView.swift
//  OpenWeather
//
//  Created by 김상규 on 7/17/24.
//

import UIKit
import MapKit
import SnapKit

class SelectLocationMapView: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.title = "위치 선택하기"
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(mapView)
    }
    
    private func configureLayout() {
        // MARK: addSubView()
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalTo(view)
        }
    }
    
    private func configureView() {
        // MARK: addSubView()
    }
}
