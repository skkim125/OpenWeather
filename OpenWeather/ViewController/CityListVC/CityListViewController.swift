//
//  CityListViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

class CityListViewController: UIViewController {
    var viewModel: WeatherViewModel?
    
    private lazy var cityListTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.id)
        tv.rowHeight = 60
        tv.backgroundColor = .clear
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
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
    
    func configureHierarchy() {
        view.addSubview(cityListTableView)
    }
    
    func configureLayout() {
        cityListTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.inputCityList.value.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.id, for: indexPath) as! CityListTableViewCell
        
        cell.configureView()
        
        return cell
    }
}
