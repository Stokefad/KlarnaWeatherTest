//
//  LocationService.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import CoreLocation
import Foundation

public final class LocationService: NSObject, ILocationService {
    private let locationManager = CLLocationManager()
    private var currentCompletion: ((CLLocation?) -> ())?
    
    public var shouldAskForLocationServicesUseAfterDenied: Bool {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus == .denied
        } else {
            return false
        }
    }
    
    public var shouldAskForLocationServicesUse: Bool {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .notDetermined
        } else {
            return false
        }
    }
    
    public override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }

    public func getCurrentLocation(completion: @escaping (CLLocation?) -> ()) {
        currentCompletion = completion
        locationManager.requestLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentCompletion?(locations.first)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentCompletion?(nil)
    }
}
