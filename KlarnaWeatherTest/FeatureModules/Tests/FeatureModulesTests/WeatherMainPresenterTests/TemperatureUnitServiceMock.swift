//
//  File.swift
//  
//
//  Created by Igor Naumenko on 02.09.2023.
//

import Foundation
@testable import TemperatureUnitPickedService

final class TemperatureUnitServiceMock: ITemperatureUnitPickedService {
    var currentUnit: TemperatureUnitDomain {
        .kelvin
    }
    
    func save(unit: TemperatureUnitDomain) {
        
    }
}
