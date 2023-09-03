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

protocol IWeatherDomainConverter {
    func convert(_ domain: WeatherDomain, currentTemperatureUnit: TemperatureUnitDomain) -> Weather
}

final class WeatherDomainConverter: IWeatherDomainConverter {
    
    private let cityDomainConverter: ICityDomainConverter
    
    public init(cityDomainConverter: ICityDomainConverter) {
        self.cityDomainConverter = cityDomainConverter
    }
    
    func convert(_ domain: WeatherDomain, currentTemperatureUnit: TemperatureUnitDomain) -> Weather {
        let temperature: String
        switch currentTemperatureUnit {
        case .celcius:
            temperature = "\(Int(domain.temperature - 273.15))°C"
        case .kelvin:
            temperature = "\(Int(domain.temperature))°K"
        case .farenheit:
            temperature = "\(Int((domain.temperature - 273.15) * (9 / 5) + 32))°F"
        }
        
        return Weather(city: cityDomainConverter.convert(domain.city), temperature: temperature)
    }
}
