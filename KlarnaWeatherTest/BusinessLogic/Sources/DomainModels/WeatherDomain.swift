//
//  Weather.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import Foundation

public struct WeatherDomain {
    public let city: CityDomain
    public let temperature: Double
    public let isInUserLocation: Bool
    
    public init(city: CityDomain, temperature: Double, isInUserLocation: Bool) {
        self.city = city
        self.isInUserLocation = isInUserLocation
        self.temperature = temperature
    }
}
