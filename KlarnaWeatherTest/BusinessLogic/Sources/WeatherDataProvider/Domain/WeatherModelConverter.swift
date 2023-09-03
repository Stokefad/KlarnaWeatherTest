//
//  WeatherModelConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import DomainModels
import Foundation

protocol IWeatherModelConverter {
    func convert(_ dto: WeatherDTO, in city: CityDomain) -> WeatherDomain
}

final class WeatherModelConverter: IWeatherModelConverter {
    func convert(_ dto: WeatherDTO, in city: CityDomain) -> WeatherDomain {
        WeatherDomain(city: city, temperature: dto.main.temp)
    }
}
