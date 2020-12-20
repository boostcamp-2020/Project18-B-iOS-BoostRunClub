//
//  RunningDashBoardServiceableMock.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation
import Foundation

class RunningDashBoardServiceableMock: RunningDashBoardServiceable {
    var runningStateSubject = PassthroughSubject<RunningState, Never>()
    var runningTime = CurrentValueSubject<TimeInterval, Never>(0)

    var location: CLLocation?
    var calorie: Double = 0
    var pace: Double = 0
    var cadence: Int = 0
    var distance: Double = 0
    var avgPace: Double = 0

    var isRunning = false
    func setState(isRunning: Bool) {
        self.isRunning = isRunning
    }

    var isStarted = false
    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }

    func clear() {
        runningTime.value = 0
        location = nil
        calorie = 0
        pace = 0
        cadence = 0
        distance = 0
        avgPace = 0
    }
}
