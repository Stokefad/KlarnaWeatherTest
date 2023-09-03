//
//  File.swift
//  
//
//  Created by Igor Naumenko on 31.08.2023.
//

import GeocoderDataProvider
import DomainModels
import UIKit
import Foundation
import SharedModels
import Utils

public protocol IWeatherSearchOutputDelegate: AnyObject {
    func cityWasPicked(city: CityDomain)
}

public final class WeatherSearchModule {
    public let viewController: UIViewController
    private weak var presenter: IWeatherSearchPresenter?
    
    init(presenter: IWeatherSearchPresenter, viewController: UIViewController) {
        self.presenter = presenter
        self.viewController = viewController
    }
}

public final class WeatherSearchAssembly {
    public static func assembly(delegate: IWeatherSearchOutputDelegate) -> WeatherSearchModule {
        let geocoder = GeocoderAssembly.assembly()
        let presenter = WeatherSearchPresenter(geocoderDataProvider: geocoder, debouncer: Debouncer(), cityDomainConverter: CityDomainConverter())
        let viewController = WeatherSearchViewController(presenter: presenter)
        presenter.view = viewController
        presenter.output = delegate
        
        return WeatherSearchModule(presenter: presenter, viewController: viewController)
    }
}
