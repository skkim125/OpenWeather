//
//  CityListViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit

class CityListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "City List"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))

    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
