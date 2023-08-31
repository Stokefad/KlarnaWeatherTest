//
//  CityDTO.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import Foundation

struct CityDTO: Decodable {
    let name: String
    let country: String
    let state: String
    let lat: Double
    let lon: Double
}
