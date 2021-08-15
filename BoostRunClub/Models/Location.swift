//
//  Location.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import CoreLocation
import Foundation

struct Location: Codable {
    let longitude: Double
    let latitude: Double
    let altitude: Double
    let speed: Int
    let timestamp: Date
}

extension Location {
    init(clLocation: CLLocation) {
        self.init(longitude: clLocation.coordinate.longitude,
                  latitude: clLocation.coordinate.latitude,
                  altitude: Double(clLocation.altitude),
                  speed: Int(clLocation.speed),
                  timestamp: clLocation.timestamp)
    }

    var coord2d: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
