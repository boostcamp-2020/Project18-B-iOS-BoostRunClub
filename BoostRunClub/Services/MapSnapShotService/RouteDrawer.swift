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

    func draw(context: CGContext, size: CGSize, locations: [CLLocation], snapshot: MKMapSnapshotter.Snapshot) {
        guard !style.lineColors.isEmpty else { return }

        context.setLineWidth(style.lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        let points = locations.map { snapshot.point(for: $0.coordinate) }
        let path = CGMutablePath()
        path.addLines(between: points)

        context.addPath(path)
        context.replacePathWithStrokedPath()
        context.clip()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [style.lineColors.first!.cgColor, style.lineColors.last!.cgColor] as CFArray
        guard
            let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors,
                locations: nil
            )
        else { return }

        context.drawLinearGradient(
            gradient,
            start: .zero,
            end: CGPoint(x: size.width, y: size.height),
            options: []
        )
    }
}
