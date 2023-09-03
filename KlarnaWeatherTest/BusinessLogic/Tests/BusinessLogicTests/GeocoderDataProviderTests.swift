//
//  File.swift
//  
//
//  Created by Igor Naumenko on 02.09.2023.
//

import XCTest
import Foundation
@testable import GeocoderDataProvider
@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    func testGeocoderSuccessResponse() throws {
        let networkServiceMock = NetworkServiceMockSuccess()
        let geocoder = GeocoderNetworkService(networkService: networkServiceMock)
        
        geocoder.getCities(for: "") { result in
            switch result {
            case let .success(cities):
                XCTAssertEqual(cities.first?.name, "SF")
                XCTAssertEqual(cities.first?.lon, 0)
            case .failure:
                XCTFail("Success response was expected")
            }
        }
    }
    
    func testGeocoderSuccessFailure() throws {
        let networkServiceMock = NetworkServiceMockFailure()
        let geocoder = GeocoderNetworkService(networkService: networkServiceMock)
        
        geocoder.getCities(for: "") { result in
            switch result {
            case .success:
                XCTFail("Failure response was expected")
            case let .failure(error):
                XCTAssertEqual(error as? GeneralError, .badResponse)
            }
        }
    }
}

