//
//  TemperatureUnitConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 30.08.2023.
//

import TemperatureUnitPickedService
import Foundation

protocol ITemperatureUnitConverter {
    func convert(_ domain: TemperatureUnitDomain) -> TemperatureUnit
}

final class TemperatureUnitConverter: ITemperatureUnitConverter {
    func convert(_ domain: TemperatureUnitDomain) -> TemperatureUnit {
        switch domain {
        case .celcius:
            return TemperatureUnit(name: "celcius")
        case .kelvin:
            return TemperatureUnit(name: "kelvin")
        case .farenheit:
            return TemperatureUnit(name: "farenheit")
        }
    }
}
