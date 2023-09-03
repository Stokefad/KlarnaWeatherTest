//
//  File.swift
//  
//
//  Created by Igor Naumenko on 30.08.2023.
//

import LocationService
import GeocoderDataProvider
import ReachabilityService
import NetworkService
import Foundation

public final class WeatherDataProviderAssembly {
    public static func assembly() -> WeatherDataProvider {
        WeatherDataProvider(
            networkService: WeatherNetworkService(networkService: NetworkService(dataTaskFactory: URLSession.shared)),
            locationService: LocationService(),
            geocoderDataProvider: GeocoderAssembly.assembly(),
            weatherModelConverter: WeatherModelConverter(),
            reachabilityService: ReachabilityService()
        )
    }
}
