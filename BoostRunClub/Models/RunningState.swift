//
//  RunningState.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import CoreLocation
import Foundation

struct RunningState {
    var location: CLLocation
    var runningTime: TimeInterval
    var calorie: Double
    var pace: Int
    var avgPace: Int
    var cadence: Int
    var distance: Double
    var isRunning: Bool = false
}
