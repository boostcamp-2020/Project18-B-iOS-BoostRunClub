//
//  GradientRouteOverlay.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/15.
//

import MapKit

class PaceGradientRouteOverlay: BasicRouteOverlay {
    let maxSpeed: CGFloat
    let minSpeed: CGFloat
    var maxColor: ColorRGBA = (0, 0, 0, 0)
    var minColor: ColorRGBA = (0, 0, 0, 0)
    var colors = [CGColor]()

    init(
        locations: [Location],
        mapRect: MKMapRect,
        colorMin: UIColor,
        colorMax: UIColor
    ) {
        let minMaxValue = locations.reduce(into: (min: Int.max, max: Int.min)) {
            $0.min = min($0.min, $1.speed)
            $0.max = max($0.max, $1.speed)
        }
        maxSpeed = CGFloat(minMaxValue.max)
        minSpeed = CGFloat(minMaxValue.min)

        minColor = colorMin.rgba
        maxColor = colorMax.rgba
        super.init(locations: locations, mapRect: mapRect)

        setColors()
    }

    private func setColors() {
        let rgbRange = (
            r: maxColor.r - minColor.r,
            g: maxColor.g - minColor.g,
            b: maxColor.b - minColor.b
        )
        let speedFactor = maxSpeed == minSpeed ? 0 : 1 / CGFloat(maxSpeed - minSpeed)

        colors = locations.reduce(into: []) {
            let factor = (CGFloat($1.speed) - minSpeed) * speedFactor
            let red = minColor.r + rgbRange.r * factor
            let green = minColor.g + rgbRange.g * factor
            let blue = minColor.b + rgbRange.b * factor
            $0.append(CGColor(red: red, green: green, blue: blue, alpha: 1))
        }
    }
}
