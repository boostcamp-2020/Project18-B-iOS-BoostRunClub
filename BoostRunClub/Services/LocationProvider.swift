//
//  LocationProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/24.
//

import Combine
import CoreLocation
import Foundation

protocol LocationProvidable {
    var locationSubject: PassthroughSubject<CLLocation, Never> { get }
    func startBackgroundTask()
    func stopBackgroundTask()
}

class LocationProvider: NSObject, LocationProvidable {
//    static var shared = LocationProvider()
    let locationManager: CLLocationManager
    private(set) var locationSubject = PassthroughSubject<CLLocation, Never>()

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.showsBackgroundLocationIndicator = true
    }

    func startBackgroundTask() {
        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startUpdatingLocation()
    }

    func stopBackgroundTask() {
//        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }
}

// MARK: - CLLocationManagerDelegate Implementation

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        locationSubject.send(location)
    }
}
