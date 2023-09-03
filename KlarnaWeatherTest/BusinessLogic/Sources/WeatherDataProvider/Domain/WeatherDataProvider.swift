//
//  WeatherDataProvider.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import DomainModels
import GeocoderDataProvider
import LocationService
import Foundation
import CoreLocation

public protocol IWeatherDataProviderDelegate: AnyObject {
    func didUpdateCurrentWeather()
    func errorOccured(error: WeatherDataProviderError)
}

public enum WeatherDataProviderError: Error {
    case locationError, geocoderError, noWeatherForLocation
}

public class WeatherDataProvider: IWeatherDataProvider {
    public weak var delegate: IWeatherDataProviderDelegate?
    
    private let networkService: IWeatherNetworkService
    private let geocoderDataProvider: IGeocoderDataProvider
    private let locationService: ILocationService
    private let weatherModelConverter: IWeatherModelConverter
    
    public var currentWeather: WeatherDomain? {
        didSet {
            delegate?.didUpdateCurrentWeather()
        }
    }
    
    init(
        networkService: IWeatherNetworkService,
        locationService: ILocationService,
        geocoderDataProvider: IGeocoderDataProvider,
        weatherModelConverter: IWeatherModelConverter
    ) {
        self.networkService = networkService
        self.locationService = locationService
        self.geocoderDataProvider = geocoderDataProvider
        self.weatherModelConverter = weatherModelConverter
    }
    
    public func updateCurrentLocationWeather() {
        locationService.getCurrentLocation { [weak self] location in
            guard let location else {
                self?.delegate?.errorOccured(error: .locationError)
                return
            }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            self?.geocoderDataProvider.getCity(lat: lat, lon: lon, completion: { [weak self] result in
                switch result {
                case .success(let city):
                    self?.updateWeather(city: city)
                case .failure:
                    self?.currentWeather = nil
                    self?.delegate?.errorOccured(error: .geocoderError)
                }
            })
        }
    }
    
    public func updateWeather(city: CityDomain) {
        networkService.requestWeather(
            lat: city.lat,
            lon: city.lon,
            completion: { [weak self] result in
                switch result {
                case let .success(weather):
                    self?.currentWeather = self?.weatherModelConverter.convert(weather, in: city)
                case .failure:
                    self?.currentWeather = nil
                    self?.delegate?.errorOccured(error: .noWeatherForLocation)
                }
            }
        )
    }
}
