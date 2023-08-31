//
//  IWeatherDataProvider.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import DomainModels
import Foundation

public protocol IWeatherDataProvider {
    var currentWeather: WeatherDomain? { get }
    func updateCurrentLocationWeather()
    func updateWeather(city: CityDomain)
}
