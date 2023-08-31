//
//  File.swift
//  
//
//  Created by Igor Naumenko on 30.08.2023.
//

import Foundation

public final class GeocoderAssembly {
    public static func assembly() -> GeocoderDataProvider {
        GeocoderDataProvider(geocoderNetworkService: GeocoderNetworkService())
    }
}
