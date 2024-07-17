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
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        
        return searchBar
    }()
    
    var viewModel = CityListViewModel()
    var moveData: ((City)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        bindData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "City List"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        navigationController?.isToolbarHidden = true
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
    
    func bindData() {
        viewModel.inputTrigger.value = ()
        
        viewModel.outputfilterList.bind { [weak self] _ in
            guard let self = self else { return }
            self.cityListTableView.reloadData()
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputfilterList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.id, for: indexPath) as! CityListTableViewCell
        let data = viewModel.outputfilterList.value[indexPath.row]
        
        let isHidden = (data.id == viewModel.inputCity.value?.id ?? 0) ? false : true
        cell.configureView(city: data, isHidden: isHidden)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.outputfilterList.value[indexPath.row]
        showAlert(city: data)
    }
    
    func showAlert(city: City) {
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        let pickCity = UIAlertAction(title: "확인", style: .default) { _ in
            self.moveData?(city)
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
        
        if searchText.isEmpty {
            viewModel.outputfilterList.value = viewModel.inputCityList.value
        } else {
            filterCities(text: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        
        viewModel.outputfilterList.value = viewModel.inputCityList.value
    }
    
    func filterCities(text: String) {
        var filterList: [City] = []
        
        for city in viewModel.inputCityList.value {
            if city.name.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) {
                filterList.append(city)
            }
        }
        
        viewModel.outputfilterList.value = filterList
    }
}
