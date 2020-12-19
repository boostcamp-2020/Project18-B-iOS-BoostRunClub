//
//  RouteSnapShotProcessor.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/10.
//

import Foundation
import MapKit
import UIKit.UIImage

protocol MapSnapShotProcessor {
    func process(snapShot: MKMapSnapshotter.Snapshot?) -> Data?
}

class RouteSnapShotProcessor: MapSnapShotProcessor {
    private let drawable: RouteDrawable
    private let locations: [CLLocation]

    init(locations: [CLLocation], drawable: RouteDrawable) {
        self.drawable = drawable
        self.locations = locations
    }

    func process(snapShot: MKMapSnapshotter.Snapshot?) -> Data? {
        guard let snapShot = snapShot else { return nil }
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(snapShot.image.size, false, UIScreen.main.scale)

        snapShot.image.draw(at: .zero)

        guard
            let context = UIGraphicsGetCurrentContext(),
            locations.count > 1
        else {
            return UIGraphicsGetImageFromCurrentImageContext()?.pngData()
        }

        drawable.draw(
            context: context,
            size: snapShot.image.size,
            locations: locations,
            snapshot: snapShot
        )

        return UIGraphicsGetImageFromCurrentImageContext()?.pngData()
    }
}
