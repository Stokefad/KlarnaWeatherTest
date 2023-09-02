//
//  File.swift
//  
//
//  Created by Igor Naumenko on 02.09.2023.
//

import Foundation
@testable import WeatherMain
@testable import WeatherDataProvider
@testable import DomainModels

final class WeatherDataProviderMockWithWeatherData: IWeatherDataProvider {
    var delegate: IWeatherDataProviderDelegate?
    
    var currentWeather: WeatherDomain? {
        WeatherDomain(city: .init(name: "SF", lat: 0, lon: 0, country: "US", state: "CA"), temperature: 233)
    }
    
    func updateCurrentLocationWeather() {
        
    }
    
    func updateWeather(city: CityDomain) {
        
    }
}

final class WeatherDataProviderMockWithError: IWeatherDataProvider {
    var delegate: IWeatherDataProviderDelegate?
    
    var currentWeather: WeatherDomain? {
        nil
    }
    
    func updateCurrentLocationWeather() {
        delegate?.errorOccured(error: .geocoderError)
    }
    
    func updateWeather(city: CityDomain) {
        delegate?.errorOccured(error: .noWeatherForLocation)
    }
}
