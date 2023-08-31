//
//  CityDomainConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import DomainModels
import Foundation

public final class CityDomainConverter {
    public static func convert(_ domain: CityDomain) -> City {
        .init(name: domain.name + ", " + domain.country + ", " + domain.state)
    }
}
