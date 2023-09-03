//
//  CityDTO.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import Foundation

public struct CityDTO: Decodable {
    init(
        name: String,
        country: String,
        state: String,
        lat: Double,
        lon: Double
    ) {
        self.name = name
        self.country = country
        self.state = state
        self.lat = lat
        self.lon = lon
    }

    let name: String
    let country: String
    let state: String
    let lat: Double
    let lon: Double
}
