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
import SharedModels
import Foundation

protocol IWeatherPresenter: AnyObject {
    var availableTemperatureUnitsForPresentation: [TemperatureUnit] { get }
    var selectedTemperatureUnitIndex: Int { get }
    func viewDidLoad()
    func openSearchAnotherLocation()
    func didChangeTemperatureUnit(at index: Int)
    func cityWasPicked(city: CityDomain)
}

final class WeatherPresenter: IWeatherPresenter {
    weak var view: IWeatherViewController?
    weak var delegate: IWeatherModuleDelegate?
    
    private let weatherDataProvider: IWeatherDataProvider
    private let unitPickedService: ITemperatureUnitPickedService
    private let weatherDomainConverter: IWeatherDomainConverter
    private let errorConverter: IErrorConverter
    private let temperatureUnitConverter: ITemperatureUnitConverter
    
    var availableTemperatureUnitsForPresentation: [TemperatureUnit] {
        availableTemperatureUnits.map { self.temperatureUnitConverter.convert($0) }
    }
    
    var selectedTemperatureUnitIndex: Int {
        availableTemperatureUnits.firstIndex(of: unitPickedService.currentUnit) ?? 0
    }
    
    private let availableTemperatureUnits: [TemperatureUnitDomain] = [.celcius, .farenheit, .kelvin]
    
    init(
        weatherDataProvider: IWeatherDataProvider,
        unitPickedService: ITemperatureUnitPickedService,
        weatherDomainConverter: IWeatherDomainConverter,
        errorConverter: IErrorConverter,
        temperatureUnitConverter: ITemperatureUnitConverter
    ) {
        self.weatherDataProvider = weatherDataProvider
        self.unitPickedService = unitPickedService
        self.weatherDomainConverter = weatherDomainConverter
        self.errorConverter = errorConverter
        self.temperatureUnitConverter = temperatureUnitConverter
    }
    
    func viewDidLoad() {
        weatherDataProvider.updateCurrentLocationWeather()
    }
    
    func openSearchAnotherLocation() {
        delegate?.searchAnotherLocationClicked()
    }
    
    func didChangeTemperatureUnit(at index: Int) {
        unitPickedService.save(unit: availableTemperatureUnits[index])
        didUpdateCurrentWeather()
    }
    
    func cityWasPicked(city: CityDomain) {
        weatherDataProvider.updateWeather(city: city)
    }
}

extension WeatherPresenter: IWeatherDataProviderDelegate {
    func didUpdateCurrentWeather() {
        DispatchQueue.main.async {
            self.view?.weather = self.weatherDataProvider.currentWeather.map { self.weatherDomainConverter.convert($0, currentTemperatureUnit: self.unitPickedService.currentUnit) }
        }
    }
    
    func errorOccured(error: WeatherDataProviderError) {
        DispatchQueue.main.async {
            self.view?.present(errorTitle: "Error", errorText: self.errorConverter.convert(error))
        }
    }
}
