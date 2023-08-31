//
//  WeatherPresenter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import TemperatureUnitPickedService
import DomainModels
import GeocoderDataProvider
import WeatherDataProvider
import Foundation

protocol IWeatherPresenter {
    var availableTemperatureUnitsForPresentation: [TemperatureUnit] { get }
    var selectedTemperatureUnitIndex: Int { get }
    func viewDidLoad()
    func openSearchAnotherLocation()
    func didChangeTemperatureUnit(at index: Int)
}

final class WeatherPresenter: IWeatherPresenter {
    weak var view: IWeatherViewController?
    private let weatherDataProvider: IWeatherDataProvider
    private let unitPickedService: ITemperatureUnitPickedService
    
    var availableTemperatureUnitsForPresentation: [TemperatureUnit] {
        availableTemperatureUnits.map { TemperatureUnitConverter.convert($0) }
    }
    
    var selectedTemperatureUnitIndex: Int {
        availableTemperatureUnits.firstIndex(of: unitPickedService.currentUnit) ?? 0
    }
    
    private let availableTemperatureUnits: [TemperatureUnitDomain] = [.celcius, .farenheit, .kelvin]
    
    init(weatherDataProvider: IWeatherDataProvider, unitPickedService: ITemperatureUnitPickedService) {
        self.weatherDataProvider = weatherDataProvider
        self.unitPickedService = unitPickedService
    }
    
    func viewDidLoad() {
        weatherDataProvider.updateCurrentLocationWeather()
    }
    
    func openSearchAnotherLocation() {
        let dataProvider = GeocoderAssembly.assembly()
        let presenter = WeatherSearchPresenter(geocoderDataProvider: dataProvider, unitPickedService: unitPickedService)
        let viewController = WeatherSearchViewController(presenter: presenter)
        presenter.view = viewController
        presenter.output = self
        
        view?.present(viewController, animated: true)
    }
    
    func didChangeTemperatureUnit(at index: Int) {
        unitPickedService.save(unit: availableTemperatureUnits[index])
        didUpdateCurrentWeather()
    }
}

extension WeatherPresenter: IWeatherDataProviderDelegate {
    func didUpdateCurrentWeather() {
        DispatchQueue.main.async {
            self.view?.weather = self.weatherDataProvider.currentWeather.map { WeatherDomainConverter.convert($0, currentTemperatureUnit: self.unitPickedService.currentUnit) }
        }
    }
    
    func errorOccured(error: WeatherDataProviderError) {
        view?.present(errorTitle: "Error", errorText: ErrorConverter.convert(error))
    }
}

extension WeatherPresenter: IWeatherSearchOutputDelegate {
    func cityWasPicked(city: CityDomain) {
        weatherDataProvider.updateWeather(city: city)
    }
}
