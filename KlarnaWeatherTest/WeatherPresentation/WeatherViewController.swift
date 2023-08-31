//
//  WeatherViewController.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import UIComponentsLibrary
import UIKit
import Foundation

protocol IWeatherViewController: UIViewController {
    var weather: Weather? { get set }
    func present(errorTitle: String, errorText: String)
}

final class WeatherViewController: UIViewController, IWeatherViewController {
    private let presenter: IWeatherPresenter
    
    private lazy var weatherInfoView = WeatherInfoView()
    
    private lazy var anotherLocationButton: UIButton = {
        let button = ButtonFactory.regular()
        button.setTitle("Another location", for: .normal)
        button.addTarget(self, action: #selector(anotherLocationWasTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: presenter.availableTemperatureUnitsForPresentation.map { $0.name })
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = ColorPalette.backgroundColor
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        return segmentControl
    }()
    
    var weather: Weather? {
        didSet {
            weatherInfoView.temperature = weather?.temperature
            weatherInfoView.city = weather?.city.name
        }
    }
    
    init(presenter: IWeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    func present(errorTitle: String, errorText: String) {
        let action = UIAlertAction(title: "Ok", style: .default)
        let alertController = UIAlertController(title: errorTitle, message: errorText, preferredStyle: .alert)
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(weatherInfoView)
        view.addSubview(anotherLocationButton)
        view.addSubview(segmentControl)
        
        segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: Indents.big * 3).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        segmentControl.bottomAnchor.constraint(lessThanOrEqualTo: weatherInfoView.bottomAnchor, constant: -Indents.regular).isActive = true
        
        weatherInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        
        anotherLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Indents.big).isActive = true
        anotherLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        anotherLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        anotherLocationButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.backgroundColor = ColorPalette.backgroundColor
        
        segmentControl.selectedSegmentIndex = presenter.selectedTemperatureUnitIndex
    }
    
    @objc
    private func anotherLocationWasTapped() {
        presenter.openSearchAnotherLocation()
    }
    
    @objc
    private func segmentControlValueChanged() {
        presenter.didChangeTemperatureUnit(at: segmentControl.selectedSegmentIndex)
    }
}
