//
//  GeocoderDataProvider.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import DomainModels
import NetworkService
import Foundation

public protocol IGeocoderDataProvider {
    func getCities(for text: String, completion: @escaping (Result<[CityDomain], Error>) -> ())
    func getCity(lat: Double, lon: Double, completion: @escaping (Result<CityDomain, Error>) -> ())
}

public final class GeocoderDataProvider: IGeocoderDataProvider {
    
    private let geocoderNetworkService: IGeocoderNetworkService
    
    init(geocoderNetworkService: IGeocoderNetworkService) {
        self.geocoderNetworkService = geocoderNetworkService
    }
    
    public func getCities(for text: String, completion: @escaping (Result<[CityDomain], Error>) -> ()) {
        geocoderNetworkService.getCities(for: text) { result in
            switch result {
            case .success(let cities):
                completion(.success(cities.map { CityDTOConverter.convert($0) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCity(lat: Double, lon: Double, completion: @escaping (Result<CityDomain, Error>) -> ()) {
        geocoderNetworkService.getCities(lat: lat, lon: lon) { result in
            switch result {
            case .success(let citiesDTO):
                if let cityDTO = citiesDTO.first {
                    completion(.success(CityDTOConverter.convert(cityDTO)))
                } else {
                    completion(.failure(DomainError.noDataForUrl))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
