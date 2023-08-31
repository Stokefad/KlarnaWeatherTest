//
//  IWeatherNetworkService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import Foundation

public protocol IWeatherNetworkService {
    func requestWeather(lat: CGFloat, lon: CGFloat, completion: @escaping (Result<WeatherDTO, Error>) -> ())
}
