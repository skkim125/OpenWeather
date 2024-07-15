//
//  CityListViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

final class CityListViewController: UIViewController {
    private lazy var cityListTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.id)
        tv.rowHeight = 60
        tv.backgroundColor = .clear
        tv.indicatorStyle = .white
        
        return tv
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        
        return searchBar
    }()
    
    var viewModel: WeatherViewModel?
    var moveData: ((City, WeatherViewModel)->())?
    private var cities: [City] = []
    private var filteredCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let array = viewModel?.inputCityList.value {
            filteredCities = array
            cities = array
            cityListTableView.reloadData()
        }
        
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
        navigationController?.isNavigationBarHidden = false
        
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
            make.height.equalTo(40)
        }
        
        cityListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.id, for: indexPath) as! CityListTableViewCell
        let data = filteredCities[indexPath.row]
        if let id =  viewModel?.inputCityID.value {
            let isHidden = (data.id == id) ? false : true
            cell.configureView(city: data, isHidden: isHidden)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filteredCities[indexPath.row]
            showAlert(city: data)
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

extension CityListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            if let array = viewModel?.inputCityList.value {
                filteredCities = array
            }
        } else {
            filterCities(text: searchText)
        }
        cityListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        
        if let array = viewModel?.inputCityList.value {
            filteredCities = array
        }
        cityListTableView.reloadData()
    }
    
    func filterCities(text: String) {
        var filtering: [City] = []
        
        for city in cities {
            if city.name.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) {
                filtering.append(city)
            }
        }
        
        filteredCities = filtering
    }
}
