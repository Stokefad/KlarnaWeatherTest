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
import ReachabilityService
import NetworkService

public protocol IWeatherDataProviderDelegate: AnyObject {
    func didUpdateCurrentWeather()
    func errorOccured(error: WeatherDataProviderError, isNetworkAvailable: Bool)
    func askUserToGrantLocationUsagePermission()
    func locationPermissionWasNotGranted()
    func geocoderLoadingStarted()
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
    private let reachabilityService: IReachabilityService
    
    private var latestCompletion: (() -> ())?
    
    public var currentWeather: WeatherDomain? {
        didSet {
            delegate?.didUpdateCurrentWeather()
        }
    }
    
    init(
        networkService: IWeatherNetworkService,
        locationService: ILocationService,
        geocoderDataProvider: IGeocoderDataProvider,
        weatherModelConverter: IWeatherModelConverter,
        reachabilityService: IReachabilityService
    ) {
        self.networkService = networkService
        self.locationService = locationService
        self.geocoderDataProvider = geocoderDataProvider
        self.weatherModelConverter = weatherModelConverter
        self.reachabilityService = reachabilityService
    }
    
    public func updateCurrentLocationWeather() {
        if locationService.shouldAskForLocationServicesUse {
            delegate?.locationPermissionWasNotGranted()
        }
        guard !locationService.shouldAskForLocationServicesUseAfterDenied else {
            delegate?.askUserToGrantLocationUsagePermission()
            return
        }
        locationService.getCurrentLocation { [weak self] location in
            guard let location, let self, self.currentWeather?.isInUserLocation == true || self.currentWeather == nil else {
                return
            }
            
            self.delegate?.geocoderLoadingStarted()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            self.geocoderGetCity(lat: lat, lon: lon)
        }
    }
    
    public func updateWeather(city: CityDomain) {
        requestWeather(city: city, isInUserLocation: false)
    }
    
    private func requestWeather(city: CityDomain, isInUserLocation: Bool) {
        networkService.requestWeather(
            lat: city.lat,
            lon: city.lon,
            completion: { [weak self] result in
                switch result {
                case let .success(weather):
                    self?.currentWeather = self?.weatherModelConverter.convert(weather, in: city, isInUserLocation: isInUserLocation)
                case let .failure(error):
                    guard error as? GeneralError != .cancelled else { return }
                    self?.updateWeatherErrorOccured(city: city)
                }
            }
        )
    }
    
    private func geocoderGetCity(lat: Double, lon: Double) {
        geocoderDataProvider.getCity(lat: lat, lon: lon, completion: { [weak self] result in
            switch result {
            case .success(let city):
                self?.requestWeather(city: city, isInUserLocation: true)
            case let .failure(error):
                guard error as? GeneralError != .cancelled else { return }
                self?.geocoderErrorOccured(lat: lat, lon: lon)
            }
        })
    }
    
    private func geocoderErrorOccured(lat: Double, lon: Double) {
        currentWeather = nil
        delegate?.errorOccured(error: .geocoderError, isNetworkAvailable: reachabilityService.isConnectedToNetwork())
        
        subscribeToReachabilityChanges { [weak self] in
            self?.geocoderGetCity(lat: lat, lon: lon)
        }
    }
    
    private func updateWeatherErrorOccured(city: CityDomain) {
        currentWeather = nil
        delegate?.errorOccured(error: .noWeatherForLocation, isNetworkAvailable: reachabilityService.isConnectedToNetwork())
        
        subscribeToReachabilityChanges { [weak self] in
            self?.requestWeather(city: city, isInUserLocation: false)
        }
    }
    
    private func subscribeToReachabilityChanges(completion: @escaping () -> ()) {
        guard !reachabilityService.isConnectedToNetwork() else { return }
        
        latestCompletion = completion
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityWasChanged), name: Notification.Name(rawValue: "NetworkStatusChanged"), object: nil)
    }
    
    @objc
    private func reachabilityWasChanged() {
        guard reachabilityService.isConnectedToNetwork() else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.latestCompletion?()
        }
    }
}
