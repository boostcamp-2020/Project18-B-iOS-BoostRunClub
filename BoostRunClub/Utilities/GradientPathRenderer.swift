//
//  GradientPathRenderer.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/13.
//

import MapKit

/// Draws a given polyline with a gradient fill, use in place of a MKOverlayPathRenderer
class GradientPathRenderer: MKOverlayPathRenderer {
    var polyline: MKPolyline
    var colors: [UIColor]

    private var cgColors: [CGColor] {
        return colors.map { (color) -> CGColor in
            color.cgColor
        }
    }

    init(polyline: MKPolyline, colors: [UIColor]) {
        self.polyline = polyline
        self.colors = colors

        super.init(overlay: polyline)
    }

    // MARK: Override methods

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        /*
         Set path width relative to map zoom scale
         */
        let baseWidth: CGFloat = lineWidth / zoomScale

        context.setLineWidth(baseWidth * 2)
        context.setLineJoin(CGLineJoin.round)
        context.setLineCap(CGLineCap.round)
        context.addPath(path)
        context.setStrokeColor(UIColor.systemGray6.withAlphaComponent(0.8).cgColor)
        context.strokePath()

        /*
         Create a gradient from the colors provided with evenly spaced stops
         */
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let stopValues = calculateNumberOfStops()
        let locations: [CGFloat] = stopValues
        let gradient = CGGradient(colorsSpace: colorspace, colors: cgColors as CFArray, locations: locations)

        /*
         Define path properties and add it to context
         */
        context.setLineWidth(baseWidth)
        context.setLineJoin(CGLineJoin.round)
        context.setLineCap(CGLineCap.round)

        context.addPath(path)

        /*
         Replace path with stroked version so we can clip
         */
        context.saveGState()

        context.replacePathWithStrokedPath()
        context.clip()

        /*
         Create bounding box around path and get top and bottom points
         */
        let boundingBox = path.boundingBoxOfPath
        let gradientStart = boundingBox.origin
        let gradientEnd = CGPoint(x: boundingBox.maxX, y: boundingBox.maxY)

        /*
         Draw the gradient in the clipped context of the path
         */
        if let gradient = gradient {
            context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }

        context.restoreGState()

        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }

    /*
     Create path from polyline
     Thanks to Adrian Schoenig
     (http://adrian.schoenig.me/blog/2013/02/21/drawing-multi-coloured-lines-on-an-mkmapview/ )
     */
    override func createPath() {
        let path = CGMutablePath()
        var pathIsEmpty: Bool = true

        for index in 0 ... polyline.pointCount - 1 {
            let point: CGPoint = self.point(for: polyline.points()[index])
            if pathIsEmpty {
                path.move(to: point)
                pathIsEmpty = false
            } else {
                path.addLine(to: point)
            }
        }
        self.path = path
    }

    // MARK: Helper Methods

    private func calculateNumberOfStops() -> [CGFloat] {
        let stopDifference = (1 / Double(cgColors.count))

        return Array(stride(from: 0, to: 1 + stopDifference, by: stopDifference))
            .map { (value) -> CGFloat in
                CGFloat(value)
            }
    }
}
