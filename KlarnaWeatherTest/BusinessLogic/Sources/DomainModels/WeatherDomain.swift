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
    
    public init(city: CityDomain, temperature: Double) {
        self.city = city
        self.temperature = temperature
    }
}
