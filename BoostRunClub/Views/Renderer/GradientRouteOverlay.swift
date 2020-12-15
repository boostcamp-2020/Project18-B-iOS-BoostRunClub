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
    var maxHue: CGFloat
    var minHue: CGFloat
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

        minHue = colorMin.hsba.hue
        maxHue = colorMax.hsba.hue
        maxHue += minHue > maxHue ? 1 : 0

        super.init(locations: locations, mapRect: mapRect)

        setColors()
    }

    private func setColors() {
        let hueRange = maxHue - minHue

        let speedFactor: CGFloat = 0.05
        var hue = minHue
        var speed: CGFloat = 0
        for (idx, location) in locations.enumerated() {
            let factor: CGFloat
            if idx != 0 {
                let delta = (CGFloat(location.speed) - CGFloat(locations[idx - 1].speed)) * speedFactor
                speed = delta == 0 ? 0 : speed + delta
            }
            hue = clamped(value: hue + speed, minValue: minHue, maxValue: maxHue)

            let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            colors.append(color.cgColor)
            print("min \(minHue) ,max \(maxHue) ,hue: \(hue), color: \(color.hsba.hue)")
        }
    }
}
