//
//  File.swift
//  
//
//  Created by Igor Naumenko on 31.08.2023.
//

import WeatherMain
import WeatherSearch
import Foundation
import UIKit
import DomainModels

public final class WeatherCoordinator {
    private lazy var weatherMain = WeatherMainAssembly.assembly(delegate: self)
    private lazy var weatherSearch = WeatherSearchAssembly.assembly(delegate: self)
    
    private weak var window: UIWindow?
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        window?.rootViewController = weatherMain.viewController
        window?.makeKeyAndVisible()
    }
}

extension WeatherCoordinator: IWeatherModuleDelegate {
    public func searchAnotherLocationClicked() {
        weatherMain.viewController.present(weatherSearch.viewController, animated: true)
    }
}

extension WeatherCoordinator: IWeatherSearchOutputDelegate {
    public func cityWasPicked(city: CityDomain) {
        weatherMain.cityWasPicked(city: city)
        weatherSearch.viewController.dismiss(animated: true)
    }
}
