//
//  GradientRouteRenderer.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/15.
//

import MapKit

class GradientRouteRenderer: MKOverlayPathRenderer {
    var routeOverlay: PaceGradientRouteOverlay

    var borderColor: UIColor = .white

    init(overlay: PaceGradientRouteOverlay) {
        routeOverlay = overlay
        super.init(overlay: overlay)
    }

    override func draw(_: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard routeOverlay.locations.count > 2 else { return }
        let baseWidth = lineWidth / zoomScale
        let points = routeOverlay.locations.map { self.point(for: MKMapPoint($0.coord2d)) }

        let borderPath = CGMutablePath()
        borderPath.addLines(between: points)

        context.setLineWidth(baseWidth * 2)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        context.addPath(borderPath)
        context.setStrokeColor(borderColor.cgColor)
        context.strokePath()

        for idx in 0 ..< (points.count - 1) {
            let startPoint = points[idx]
            let endPoint = points[idx + 1]
            let startColor = routeOverlay.colors[idx]
            let endColor = routeOverlay.colors[idx + 1]

            context.setLineWidth(baseWidth)
            context.setLineJoin(.round)
            context.setLineCap(.round)

            let path = CGMutablePath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)

            context.addPath(path)
            context.saveGState()

            context.replacePathWithStrokedPath()
            context.clip()

            guard
                let gradient = CGGradient(
                    colorsSpace: nil,
                    colors: [startColor, endColor] as CFArray,
                    locations: [0, 1]
                )
            else {
                context.restoreGState()
                continue
            }

            context.drawLinearGradient(
                gradient, start: startPoint,
                end: endPoint,
                options: [
                    .drawsAfterEndLocation,
                    .drawsBeforeStartLocation,
                ]
            )
            context.restoreGState()
        }
    }
}
