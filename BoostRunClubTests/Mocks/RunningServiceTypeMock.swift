//
//  RunningServiceTypeMock.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

class RunningServiceTypeMock: RunningServiceType {
    var dashBoardService: RunningDashBoardServiceable
    var recordService: RunningRecordServiceable

    init(
        dashBoard: RunningDashBoardServiceable,
        recorder: RunningRecordServiceable,
        motionProvider _: RunningMotionServiceable
    ) {
        dashBoardService = dashBoard
        recordService = recorder
    }

    var runningResultSubject = PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never>()
    var runningStateSubject = CurrentValueSubject<MotionType, Never>(.standing)
    var runningEventSubject = PassthroughSubject<RunningEvent, Never>()
    var isStarted: Bool = false
    var isPaused: Bool = false
    var autoResume: Bool = true

    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }

    func pause(autoResume: Bool) {
        self.autoResume = autoResume
        isPaused = true
    }

    func resume() {
        isPaused = false
    }

    var goalInfo: GoalInfo?
    func setGoal(_ goalInfo: GoalInfo?) {
        self.goalInfo = goalInfo
    }
}
