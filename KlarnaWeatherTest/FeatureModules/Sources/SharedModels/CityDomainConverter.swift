//
//  CityDomainConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import DomainModels
import Foundation

public protocol ICityDomainConverter {
    func convert(_ domain: CityDomain) -> City
}

public final class CityDomainConverter: ICityDomainConverter {
    public init() {}
    
    public func convert(_ domain: CityDomain) -> City {
        .init(name: domain.name + ", " + domain.country + ", " + domain.state)
    }
}
