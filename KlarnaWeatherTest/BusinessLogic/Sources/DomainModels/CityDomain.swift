//
//  CityDomain.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import Foundation

public struct CityDomain {
    public let name: String
    public let lat: Double
    public let lon: Double
    public let country: String
    public let state: String
    
    public init(name: String, lat: Double, lon: Double, country: String, state: String) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
}
