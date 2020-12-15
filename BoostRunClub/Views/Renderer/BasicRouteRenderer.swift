//
//  BasicRouteRenderer.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/15.
//

import MapKit

class BasicRouteRenderer: MKOverlayPathRenderer {
    var routeOverlay: BasicRouteOverlay

    init(overlay: BasicRouteOverlay) {
        routeOverlay = overlay
        super.init(overlay: routeOverlay)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let baseWidth = lineWidth / zoomScale

        let locations = routeOverlay.locations

        context.setLineWidth(baseWidth)
        context.setLineJoin(.round)
        context.setLineCap(.round)

        let points = locations.map { self.point(for: MKMapPoint($0.coord2d)) }
        let paths = CGMutablePath()
        paths.addLines(between: points)

        let lineColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        context.setStrokeColor(lineColor)
        context.beginPath()
        context.addPath(paths)
        context.strokePath()

        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }
}
