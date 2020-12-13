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

    mutating func setupSlice(with locations: [CLLocation]) {
        endIndex = locations.count - 1
        if startIndex < endIndex {
            distance = (startIndex ..< endIndex).reduce(into: Double(0)) { distance, idx in
                distance += locations[idx].distance(from: locations[idx + 1])
            }
        } else {
            distance = 0
        }
    }
}
