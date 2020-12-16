//
//  RouteDrawable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/10.
//

import Foundation
import MapKit
import UIKit.UIImage

protocol RouteDrawable {
    func draw(
        context: CGContext,
        size: CGSize,
        locations: [CLLocation],
        snapshot: MKMapSnapshotter.Snapshot
    )
}

struct RouteDrawer: RouteDrawable {
    struct Style {
        let lineWidth: CGFloat
        let lineColors: [UIColor]
    }

    let style: Style

    func draw(context: CGContext, size _: CGSize, locations: [CLLocation], snapshot: MKMapSnapshotter.Snapshot) {
        guard !style.lineColors.isEmpty else { return }

        context.setLineWidth(style.lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        let points = locations.map { snapshot.point(for: $0.coordinate) }
        let path = CGMutablePath()
        path.addLines(between: points)

        let lineColor = style.lineColors.first ?? UIColor.black

        context.setStrokeColor(lineColor.cgColor)
        context.beginPath()
        context.addPath(path)
        context.strokePath()
    }
}
