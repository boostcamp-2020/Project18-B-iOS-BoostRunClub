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
    var colors = [(start: CGColor, end: CGColor)]()
    var slices = [RunningSlice]()

    init(
        locations: [Location],
        splits: [RunningSplit],
        mapRect: MKMapRect,
        colorMin: UIColor,
        colorMax: UIColor
    ) {
        slices = splits.reduce(into: []) { $0.append(contentsOf: $1.runningSlices) }
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
        let speedFactor: CGFloat = 1 / (maxSpeed - minSpeed)
        let hueFactor: CGFloat = (maxHue - minHue)

        slices.forEach { slice in
            if !slice.isRunning {
                self.colors.append((start: UIColor.black.cgColor, end: UIColor.black.cgColor))
                return
            }
            let startIdx = clamped(value: slice.startIndex, minValue: 0, maxValue: locations.count - 2)
            let endIdx = clamped(value: slice.endIndex, minValue: startIdx, maxValue: locations.count - 1)

            let startHue = minHue + (CGFloat(locations[startIdx].speed) - minSpeed) * speedFactor * hueFactor
            let endHue = minHue + (CGFloat(locations[endIdx].speed) - minSpeed) * speedFactor * hueFactor
            self.colors.append((
                start: UIColor(hue: startHue, saturation: 1, brightness: 1, alpha: 1).cgColor,
                end: UIColor(hue: endHue, saturation: 1, brightness: 1, alpha: 1).cgColor
            )
            )
        }
    }
}
