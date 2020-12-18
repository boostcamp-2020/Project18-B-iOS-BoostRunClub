//
//  RunningSlice.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/03.
//

import CoreLocation.CLLocation
import Foundation

struct RunningSlice: Codable {
    var startIndex: Int = 0
    var endIndex: Int = -1
    var distance: Double = 0
    var isRunning: Bool = false

    mutating func setupSlice(with runningStates: [RunningState]) {
        if startIndex < endIndex {
            distance = (startIndex ..< endIndex).reduce(into: Double(0)) { distance, idx in
                let newDistance = runningStates[idx].location.distance(from: runningStates[idx + 1].location)
                print("[SLICE] (\(idx) - \(idx + 1)) (D \(distance) + \(newDistance) = \(distance + newDistance)")
                print("[SLICE] (\(runningStates[idx + 1].distance) - \(runningStates[idx].distance) = \(runningStates[idx + 1].distance - runningStates[idx].distance)")
                distance += newDistance
            }
        } else {
            distance = 0
        }

        print("[SLICE] from distance: \(runningStates[endIndex].distance - runningStates[startIndex].distance)")
    }
}
