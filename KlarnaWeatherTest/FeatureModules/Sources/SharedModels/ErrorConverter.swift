//
//  ErrorConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 30.08.2023.
//

import Foundation
import WeatherDataProvider

public protocol IErrorConverter {
    func convert(_ error: WeatherDataProviderError) -> String
}

public final class ErrorConverter: IErrorConverter {
    public init() {}
    
    public func convert(_ error: WeatherDataProviderError) -> String {
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
