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
}
