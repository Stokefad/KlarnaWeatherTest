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
    var isContentVisible: Bool { get set }
    var isLoading: Bool { get set }
    var currentStateTitle: String? { get set }
    func present(title: String, message: String, actionTitle: String?, completion: (() -> ())?)
}

final class WeatherViewController: UIViewController, IWeatherViewController {
    private let presenter: IWeatherPresenter
    
    private lazy var weatherInfoView = WeatherInfoView()
    private lazy var contentStateInfoView = ContentStateInfoView()
    
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
    
    var isContentVisible = false {
        didSet {
            weatherInfoView.isHidden = !isContentVisible
            contentStateInfoView.isHidden = isContentVisible
        }
    }
    
    var isLoading = true {
        didSet {
            contentStateInfoView.isSpinnerVisible = isLoading
        }
    }
    
    var currentStateTitle: String? {
        didSet {
            contentStateInfoView.text = currentStateTitle
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
    
    func present(title: String, message: String, actionTitle: String?, completion: (() -> ())?) {
        let actionOk = UIAlertAction(title: "Ok", style: .cancel)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(actionOk)
        if let actionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                completion?()
            }
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(weatherInfoView)
        view.addSubview(anotherLocationButton)
        view.addSubview(segmentControl)
        view.addSubview(contentStateInfoView)
        
        segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: Indents.big * 4).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        segmentControl.bottomAnchor.constraint(lessThanOrEqualTo: weatherInfoView.bottomAnchor, constant: -Indents.regular).isActive = true
        
        weatherInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        weatherInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        weatherInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        
        contentStateInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentStateInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Indents.regular).isActive = true
        contentStateInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Indents.regular).isActive = true
        
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
