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
    
    public override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }

    public func getCurrentLocation(completion: @escaping (CLLocation?) -> ()) {
        if #available(iOS 14.0, *) {
            guard locationManager.authorizationStatus == .authorizedWhenInUse else { return }
        } else {
            return
        }

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
