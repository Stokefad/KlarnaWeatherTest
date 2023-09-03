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
import UIKit

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
        view?.isLoading = true
        view?.isContentVisible = false
        view?.currentStateTitle = "Loading"
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
    public func didUpdateCurrentWeather() {
        DispatchQueue.main.async {
            self.view?.isLoading = false
            self.view?.isContentVisible = true
            self.view?.weather = self.weatherDataProvider.currentWeather.map { self.weatherDomainConverter.convert($0, currentTemperatureUnit: self.unitPickedService.currentUnit) }
        }
    }
    
    public func locationPermissionWasNotGranted() {
        DispatchQueue.main.async {
            self.view?.isLoading = false
            self.view?.currentStateTitle = "Location permission needed"
        }
    }
    
    public func askUserToGrantLocationUsagePermission() {
        DispatchQueue.main.async {
            self.view?.present(title: "Location permission", message: "Please grant permission to use your location in order to show current weather", actionTitle: "Settings", completion: {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            })
        }
    }
    
    public func geocoderLoadingStarted() {
        DispatchQueue.main.async {
            self.view?.isLoading = true
            self.view?.currentStateTitle = "Loading"
        }
    }
    
    public func errorOccured(error: WeatherDataProviderError, isNetworkAvailable: Bool) {
        guard isNetworkAvailable else { return }
        DispatchQueue.main.async {
            self.view?.isLoading = false
            self.view?.currentStateTitle = self.errorConverter.convert(error)
            self.view?.present(title: "Error", message: self.errorConverter.convert(error), actionTitle: nil, completion: nil)
        }
    }
}
