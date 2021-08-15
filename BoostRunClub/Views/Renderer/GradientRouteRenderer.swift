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

        for (idx, slice) in routeOverlay.slices.enumerated() {
            let startIdx = clamped(value: slice.startIndex, minValue: 0, maxValue: points.count - 2)
            let endIdx = clamped(value: slice.endIndex, minValue: startIdx + 1, maxValue: points.count - 1)
            let startColor = routeOverlay.colors[idx].start
            let endColor = routeOverlay.colors[idx].end

            context.setLineWidth(baseWidth)
            context.setLineJoin(.round)
            context.setLineCap(.round)

            let path = CGMutablePath()
            path.move(to: points[startIdx])
            path.addLines(between: points[startIdx ... endIdx].map { $0 })

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
                gradient, start: points[startIdx],
                end: points[endIdx],
                options: [.drawsAfterEndLocation]
            )
            context.restoreGState()
        }
    }
}
