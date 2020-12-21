//
//  RunningServiceType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import Foundation

protocol RunningServiceType {
    var dashBoardService: RunningDashBoardServiceable { get }
    var recordService: RunningRecordServiceable { get }
    var runningResultSubject: PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never> { get }
    var runningStateSubject: CurrentValueSubject<MotionType, Never> { get }
    var runningEventSubject: PassthroughSubject<RunningEvent, Never> { get }
    var isStarted: Bool { get }

    func start()
    func stop()
    func pause(autoResume: Bool)
    func resume()

    func setGoal(_ goalInfo: GoalInfo?)
}
