//
//  MapSnapShotService.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/10.
//

import Combine
import Foundation
import MapKit

protocol MapSnapShotServiceable {
    func takeSnapShot(from locations: [CLLocation], size: CGSize) -> AnyPublisher<Data?, Error>
}

class MapSnapShotService: MapSnapShotServiceable {
    func takeSnapShot(
        from locations: [CLLocation],
        size: CGSize = CGSize(width: 100, height: 100)
    ) -> AnyPublisher<Data?, Error> {
        let region = MKCoordinateRegion.make(from: locations)
        let drawable = RouteDrawer(style: .init(lineWidth: 3, lineColors: [.label]))
        let processor = RouteSnapShotProcessor(locations: locations, drawable: drawable)
        return MKMapSnapshotter.Publisher(region: region, size: size, processor: processor)
            .eraseToAnyPublisher()
    }
}

extension MKMapSnapshotter {
    // swiftlint:disable:next identifier_name
    static func Publisher(
        region: MKCoordinateRegion,
        size: CGSize,
        processor: MapSnapShotProcessor
    ) -> MapSnapShotPublisher {
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        let snapshotter = MKMapSnapshotter(options: options)
        return MapSnapShotPublisher(snapshotter: snapshotter, processor: processor)
    }
}
