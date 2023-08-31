//
//  ErrorConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 30.08.2023.
//

import WeatherDataProvider
import Foundation

final class ErrorConverter {
    static func convert(_ error: WeatherDataProviderError) -> String {
        switch error {
        case .locationError:
            return "Unable to get location"
        case .noWeatherForLocation:
            return "Unable to fetch weather for location"
        case .geocoderError:
            return "Unable to fetch location"
        }
    }
}
