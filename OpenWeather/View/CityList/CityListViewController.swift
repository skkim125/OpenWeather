//
//  CityListViewController.swift
//  OpenWeather
//
//  Created by 김상규 on 7/13/24.
//

import UIKit
import SnapKit

final class CityListViewController: UIViewController {
    // MARK: - Views
    private lazy var cityListTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.id)
        tv.rowHeight = 60
        tv.backgroundColor = .clear
        tv.indicatorStyle = .default
        
        return tv
    }()
    private let dividerLine = DividerLine(color: .lightGray)
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        searchBar.searchTextField.textColor = .black
        
        return searchBar
    }()
    
    // MARK: - Properties
    var viewModel = CityListViewModel()
    var moveData: ((City)->())?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
        bindData()
    }
    
    // MARK: - Configurations
    private func configureNavigationBar() {
        navigationItem.title = "City List"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(0.8)]
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.tintColor = .darkGray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        navigationController?.isToolbarHidden = true
    }
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(dividerLine)
        view.addSubview(cityListTableView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        cityListTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(cityListTableView.snp.top)
            make.horizontalEdges.equalTo(cityListTableView)
            make.height.equalTo(0.2)
        }
    }
    
    private func configureView() {
        let image = #imageLiteral(resourceName: "gradationImg").cgImage
        view.layer.contents = image
    }
    
    // MARK: - Data Binding Functions
    func bindData() {
        viewModel.inputTrigger.value = ()
        
        viewModel.outputfilterList.bind { [weak self] _ in
            guard let self = self else { return }
            self.cityListTableView.reloadData()
        }
    }
    
    // MARK: - Button Functions
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
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

// MARK: - UITableViewDelegate, UITableViewDataSource
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
        cell.separatorInset = .zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.outputfilterList.value[indexPath.row]
        showTwoButtonAlert(title: "\(data.name)의 날씨로 이동하시겠습니까?", message: nil, checkButtonTitle: "확인") { [weak self] in
            guard let self = self else { return }
            self.moveData?(data)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
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
}
