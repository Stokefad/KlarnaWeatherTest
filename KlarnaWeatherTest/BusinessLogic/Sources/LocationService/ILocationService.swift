//
//  ILocationService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import CoreLocation
import Foundation

public protocol ILocationService {
    func getCurrentLocation(completion: @escaping (CLLocation?) -> ())
}
