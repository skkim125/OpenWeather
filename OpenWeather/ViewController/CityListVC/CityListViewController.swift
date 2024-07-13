//
//  CityListViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

class CityListViewController: UIViewController {
    private lazy var cityListTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.id)
        tv.rowHeight = 60
        tv.backgroundColor = .clear
        
        return tv
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    
    var viewModel: WeatherViewModel?
    var moveData: ((City, WeatherViewModel)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "City List"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(cityListTableView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        cityListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.inputCityList.value.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.id, for: indexPath) as! CityListTableViewCell
        
        if let data = viewModel?.inputCityList.value[indexPath.row] {
            cell.configureView(city: data)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel?.inputCityList.value[indexPath.row] {
            showAlert(city: data)
        }
    }
    
    func showAlert(city: City) {
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let pickCity = UIAlertAction(title: "확인", style: .default) { _ in
            self.moveData?(city, self.viewModel!)
            self.navigationController?.popViewController(animated: true)
        }
        
        let alert = UIAlertController(title: "\(city.name)의 날씨로 이동하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(pickCity)
        
        present(alert, animated: true)
    }
}
