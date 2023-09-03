//
//  File.swift
//  
//
//  Created by Igor Naumenko on 03.09.2023.
//

import Foundation
@testable import NetworkService
@testable import GeocoderDataProvider

final class NetworkServiceMockSuccess: INetworkService {
    func fetch<T>(url: URL, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        completion(.success([CityDTO(name: "SF", country: "US", state: "CA", lat: 0, lon: 0)] as! T))
    }
}

final class NetworkServiceMockFailure: INetworkService {
    func fetch<T>(url: URL, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        completion(.failure(GeneralError.badResponse))
    }
}
