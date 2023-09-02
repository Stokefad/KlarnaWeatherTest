//
//  WeatherSearchViewController.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import UIComponentsLibrary
import SharedModels
import UIKit
import Foundation

protocol IWeatherSearchViewController: UIViewController {
    var foundCities: [City] { get set }
}

final class WeatherSearchViewController: UIViewController, IWeatherSearchViewController {
    private let presenter: IWeatherSearchPresenter
    
    private lazy var citiesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ColorPalette.backgroundColor
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = ColorPalette.backgroundColor
        return searchBar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = ButtonFactory.regular()
        button.setTitle("Search", for: .normal)
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        return button
    }()
    
    var foundCities: [City] = [] {
        didSet {
            citiesTableView.reloadData()
        }
    }
    
    init(presenter: IWeatherSearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func present(errorTitle: String, errorText: String) {
        let action = UIAlertAction(title: "Ok", style: .default)
        let alertController = UIAlertController(title: errorTitle, message: errorText, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(searchButton)
        view.addSubview(citiesTableView)
        
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Indents.big).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Indents.small).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: Indents.regular).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -Indents.regular).isActive = true
        
        citiesTableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: Indents.regular).isActive = true
        citiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        citiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        citiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.backgroundColor = ColorPalette.backgroundColor
    }
    
    @objc
    private func search() {
        guard let text = searchBar.text, text.count > 2 else { return }
        presenter.getCities(for: text)
    }
}

extension WeatherSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        
        cell.name = foundCities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cityWasPicked(at: indexPath.row)
    }
}
