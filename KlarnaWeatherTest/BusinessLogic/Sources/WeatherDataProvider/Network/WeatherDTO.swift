//
//  WeatherDTO.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import Foundation

public struct WeatherDTO: Decodable {
    public let name: String
    public let main: Main
}

extension WeatherDTO {
    public struct Main: Decodable {
        let temp: Double
    }
    
    public struct Wind: Decodable {
        let speed: Double
        let gust: Double
    }
}
