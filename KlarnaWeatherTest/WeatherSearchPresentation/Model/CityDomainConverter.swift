//
//  CityDomainConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import DomainModels
import Foundation

final class CityDomainConverter {
    static func convert(_ domain: CityDomain) -> City {
        .init(name: domain.name + ", " + domain.country + ", " + domain.state)
    }
}
