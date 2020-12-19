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
            distance = runningStates[endIndex].distance - runningStates[startIndex].distance
        } else {
            distance = 0
        }
    }
}
