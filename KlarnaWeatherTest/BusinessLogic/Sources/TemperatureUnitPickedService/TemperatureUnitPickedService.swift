//
//  File.swift
//  
//
//  Created by Igor Naumenko on 30.08.2023.
//

import Foundation

public enum TemperatureUnitDomain: String {
    case celcius, kelvin, farenheit
}

public protocol ITemperatureUnitPickedService {
    var currentUnit: TemperatureUnitDomain { get }
    func save(unit: TemperatureUnitDomain)
}

public final class TemperatureUnitPickedService: ITemperatureUnitPickedService {
    
    public init() {}
    
    public var currentUnit: TemperatureUnitDomain {
        guard let saved = UserDefaults.standard.object(forKey: Constants.currentUnitKey) as? String
        else {
            return .celcius
        }
        return TemperatureUnitDomain(rawValue: saved) ?? .celcius
    }
    
    public func save(unit: TemperatureUnitDomain) {
        UserDefaults.standard.setValue(unit.rawValue, forKey: Constants.currentUnitKey)
    }
}

extension TemperatureUnitPickedService {
    private enum Constants {
        static let currentUnitKey = "CurrentUnitKey"
    }
}
