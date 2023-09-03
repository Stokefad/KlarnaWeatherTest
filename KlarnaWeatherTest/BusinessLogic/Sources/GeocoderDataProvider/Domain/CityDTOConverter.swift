//
//  CityDTOConverter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import DomainModels
import Foundation

protocol ICityDTOConverter {
    func convert(_ dto: CityDTO) -> CityDomain
}

final class CityDTOConverter: ICityDTOConverter {
    func convert(_ dto: CityDTO) -> CityDomain {
        CityDomain(name: dto.name, lat: dto.lat, lon: dto.lon, country: dto.country, state: dto.state)
    }
}
