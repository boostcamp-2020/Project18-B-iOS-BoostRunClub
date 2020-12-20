//
//  RunningSplit.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import CoreLocation.CLLocation
import Foundation

struct RunningSplit: Codable {
    var avgPace: Int = 0
    var distance: Double = 0
    var elevation: Int = 0
    var runningSlices = [RunningSlice]()

    mutating func setupSplit(avgPace: Int, elevation: Int) {
        self.avgPace = avgPace
        self.elevation = elevation
        distance = runningSlices.reduce(into: Double(0)) { $0 += $1.distance }
    }

    mutating func setup(with states: [RunningState]) {
        guard
            let start = runningSlices.first?.startIndex,
            let end = runningSlices.last?.endIndex
        else { return }
        let endIdx = end < states.count ? end : states.count - 1

        let sumOutput = states[start ... endIdx]
            .reduce(
                into: (
                    distance: Double(0),
                    pace: Int(0),
                    minElv: Double(9999),
                    maxElv: Double(0)
                )) {
                $0.distance += $1.distance
                $0.pace += $1.pace
                $0.minElv = min($0.minElv, $1.location.altitude)
                $0.maxElv = max($0.maxElv, $1.location.altitude)
            }
        distance = states[endIdx].distance - states[start].distance
        avgPace = sumOutput.pace / (endIdx - start + 1)
        elevation = Int(sumOutput.maxElv - sumOutput.minElv)
    }
}
