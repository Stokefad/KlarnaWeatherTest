//
//  WeatherDomainConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import TemperatureUnitPickedService
import DomainModels
import SharedModels
import Foundation

final class WeatherDomainConverter {
    static func convert(_ domain: WeatherDomain, currentTemperatureUnit: TemperatureUnitDomain) -> Weather {
        let temperature: String
        switch currentTemperatureUnit {
        case .celcius:
            temperature = "\(Int(domain.temperature - 273.15))°C"
        case .kelvin:
            temperature = "\(Int(domain.temperature))°K"
        case .farenheit:
            temperature = "\(Int((domain.temperature - 273.15) * (9 / 5) + 32))°F"
        }
        
        return Weather(city: CityDomainConverter.convert(domain.city), temperature: temperature)
    }
}
