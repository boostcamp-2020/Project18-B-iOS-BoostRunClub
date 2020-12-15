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
        guard !locations.isEmpty else { return }

        let speedFactor: CGFloat = 1 / (maxSpeed - minSpeed)
        let hueFactor: CGFloat = 1 / (maxHue - minHue)
        var hue = minHue + (CGFloat(locations[0].speed) - minSpeed) * speedFactor * hueFactor
        var speed: CGFloat = 0
        for (idx, location) in locations.enumerated() {
            if idx != 0 {
                let delta = (CGFloat(location.speed) - CGFloat(locations[idx - 1].speed)) * speedFactor * 0.5
                speed = delta == 0 ? 0 : speed + delta
            }
            hue = clamped(value: hue + speed, minValue: minHue, maxValue: maxHue)

            let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            colors.append(color.cgColor)
        }
    }
}
