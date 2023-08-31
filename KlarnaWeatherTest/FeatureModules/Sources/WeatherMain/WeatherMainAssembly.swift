//
//  File.swift
//  
//
//  Created by Igor Naumenko on 31.08.2023.
//

import Foundation
import WeatherDataProvider
import TemperatureUnitPickedService
import DomainModels
import UIKit

public protocol IWeatherModuleDelegate: AnyObject {
    func searchAnotherLocationClicked()
}

public final class WeatherMainModule {
    public let viewController: UIViewController
    private weak var presenter: IWeatherPresenter?
    
    init(presenter: IWeatherPresenter, viewController: UIViewController) {
        self.presenter = presenter
        self.viewController = viewController
    }
    
    public func cityWasPicked(city: CityDomain) {
        presenter?.cityWasPicked(city: city)
    }
}

public final class WeatherMainAssembly {
    public static func assembly(delegate: IWeatherModuleDelegate) -> WeatherMainModule {
        let dataProvider = WeatherDataProviderAssembly.assembly()
        let presenter = WeatherPresenter(weatherDataProvider: dataProvider, unitPickedService: TemperatureUnitPickedService())
        dataProvider.delegate = presenter
        let viewController = WeatherViewController(presenter: presenter)
        presenter.view = viewController
        presenter.delegate = delegate
        
        return WeatherMainModule(presenter: presenter, viewController: viewController)
    }
}
