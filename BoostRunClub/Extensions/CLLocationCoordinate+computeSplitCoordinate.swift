//
//  CLLocationCoordinate+computeSplitCoordinate.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/15.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    static func computeSplitCoordinate(from points: [CLLocationCoordinate2D], distance: Double) -> [CLLocationCoordinate2D] {
        guard let first = points.first else { return [CLLocationCoordinate2D]() }
        var previousPoint = first
        let initialValue: Double = 0.0
        var splitCoordinates = [CLLocationCoordinate2D]()

        points.reduce(initialValue) { (acculmatedDistance, currentPoint) -> Double in
            let addedDistance = acculmatedDistance + CLLocation(
                latitude: previousPoint.latitude,
                longitude: previousPoint.longitude
            ).distance(from: CLLocation(
                latitude: currentPoint.latitude,
                longitude: currentPoint.longitude
            ))

            if addedDistance >= distance {
                splitCoordinates.append(currentPoint)
                return 0
            } else {
                previousPoint = currentPoint
                return addedDistance
            }
        }

        return splitCoordinates
    }

    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)

        let dLon = lon2 - lon1

        // swiftlint:disable:next identifier_name
        let y = sin(dLon) * cos(lat2)

        // swiftlint:disable:next identifier_name
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radiansBearing)
    }

    func locationToDest(
        dest: CLLocationCoordinate2D,
        distanceMeters: Double
    ) -> CLLocationCoordinate2D {
        return .locationWithBearing(
            bearingRadians: bearing(to: dest),
            distanceMeters: distanceMeters,
            origin: self
        )
    }

    static func locationWithBearing(
        bearingRadians: Double,
        distanceMeters: Double,
        origin: CLLocationCoordinate2D
    ) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / 6_372_797.6 // earth radius in meters

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearingRadians))

        // swiftlint:disable:next line_length
        let lon2 = lon1 + atan2(sin(bearingRadians) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}
