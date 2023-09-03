//
//  GeocoderNetworkService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import NetworkService
import DomainModels
import Foundation

public protocol IGeocoderNetworkService {
    func getCities(for searchText: String, completion: @escaping (Result<[CityDTO], Error>) -> ())
    func getCities(lat: Double, lon: Double, completion: @escaping (Result<[CityDTO], Error>) -> ())
}

public final class GeocoderNetworkService: IGeocoderNetworkService {
    private let networkService: INetworkService
    
    public init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    public func getCities(for searchText: String, completion: @escaping (Result<[CityDTO], Error>) -> ()) {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(searchText)&limit=\(5)&appid=\(APIKeys.openWeatherKey)"
        
        if let url = URL(string: urlString) {
            networkService.fetch(url: url, completion: completion)
        } else {
            completion(.failure(DomainError.noDataForUrl))
        }
    }
    
    public func getCities(lat: Double, lon: Double, completion: @escaping (Result<[CityDTO], Error>) -> ()) {
        let urlString = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=\(1)&appid=\(APIKeys.openWeatherKey)"
        
        if let url = URL(string: urlString) {
            networkService.fetch(url: url, completion: completion)
        } else {
            completion(.failure(DomainError.noDataForUrl))
        }
    }
}
