//
//  WeatherNetworkService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import Foundation
import NetworkService
import DomainModels

public final class WeatherNetworkService: IWeatherNetworkService {
    private let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    public func requestWeather(lat: CGFloat, lon: CGFloat, completion: @escaping (Result<WeatherDTO, Error>) -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(WeatherNetworkServiceAPIKey.openWeatherKey)"

        if let url = URL(string: urlString) {
            networkService.fetch(url: url, completion: completion)
        } else {
            completion(.failure(DomainError.noDataForUrl))
        }
    }
}
