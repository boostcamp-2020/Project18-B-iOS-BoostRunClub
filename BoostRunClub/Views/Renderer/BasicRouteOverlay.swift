//
//  RouteOverlay.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/15.
//

import MapKit

class BasicRouteOverlay: NSObject, MKOverlay {
    var boundingMapRect: MKMapRect
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: boundingMapRect.midX, longitude: boundingMapRect.midY)
    }

    var locations: [Location]

    init(locations: [Location], mapRect _: MKMapRect) {
        self.locations = locations
        boundingMapRect = .world
    }
}
