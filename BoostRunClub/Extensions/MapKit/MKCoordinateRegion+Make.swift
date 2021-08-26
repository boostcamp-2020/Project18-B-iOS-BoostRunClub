//
//  MKCoordinateRegion+Make.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/10.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    static func make(from locations: [CLLocation], offsetRatio: Double = 0.3) -> MKCoordinateRegion {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLong: CLLocationDegrees = 180.0
        var maxLong: CLLocationDegrees = -180.0

        locations.forEach {
            let lat = $0.coordinate.latitude
            let long = $0.coordinate.longitude
            minLat = min(lat, minLat)
            maxLat = max(lat, maxLat)
            minLong = min(long, minLong)
            maxLong = max(long, maxLong)
        }
        return calculateRegion(
            minLat: minLat,
            maxLat: maxLat,
            minLong: minLong,
            maxLong: maxLong,
            offsetRatio: offsetRatio
        )
    }

    static func make(from locations: [CLLocationCoordinate2D], offsetRatio: Double = 0.3) -> MKCoordinateRegion {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLong: CLLocationDegrees = 180.0
        var maxLong: CLLocationDegrees = -180.0

        locations.forEach {
            let lat = $0.latitude
            let long = $0.longitude
            minLat = min(lat, minLat)
            maxLat = max(lat, maxLat)
            minLong = min(long, minLong)
            maxLong = max(long, maxLong)
        }

        return calculateRegion(
            minLat: minLat,
            maxLat: maxLat,
            minLong: minLong,
            maxLong: maxLong,
            offsetRatio: offsetRatio
        )
    }

    private static func calculateRegion(
        minLat: CLLocationDegrees,
        maxLat: CLLocationDegrees,
        minLong: CLLocationDegrees,
        maxLong: CLLocationDegrees,
        offsetRatio: Double
    ) -> MKCoordinateRegion {
        let southWest = CLLocation(latitude: minLat, longitude: minLong)
        let southEast = CLLocation(latitude: minLat, longitude: maxLong)
        let northEast = CLLocation(latitude: maxLat, longitude: maxLong)
        let northWest = CLLocation(latitude: maxLat, longitude: minLong)

        let latitudinalMeters = max(southWest.distance(from: northWest), southEast.distance(from: northEast))
        let longitudinalMeters = max(southWest.distance(from: southEast), northEast.distance(from: northWest))

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLong + maxLong) / 2
        )
        var delta = max(latitudinalMeters, longitudinalMeters)
        delta += delta * offsetRatio
        return MKCoordinateRegion(center: center, latitudinalMeters: delta, longitudinalMeters: delta)
    }
}
