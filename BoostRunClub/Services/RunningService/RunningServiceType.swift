//
//  RunningServiceType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreLocation
import Foundation

protocol RunningServiceType {
    var dashBoardService: RunningDashBoardServiceable { get }
    var recordService: RunningRecordServiceable { get }
    var runningResultSubject: PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never> { get }
    var runningStateSubject: CurrentValueSubject<MotionType, Never> { get }
    var runningEventSubject: PassthroughSubject<RunningEvent, Never> { get }
    var isRunning: Bool { get }

    func start()
    func stop()
    func pause()
    func resume()

    func setGoal(_ goalInfo: GoalInfo?)
}

class RunningService: RunningServiceType {
    private(set) var cancellables = Set<AnyCancellable>()
    private(set) var motionService: RunningMotionServiceable
    private(set) var dashBoardService: RunningDashBoardServiceable
    private(set) var recordService: RunningRecordServiceable

    private var startTime: Date?

    private var autoStatable = true
    var isRunning = false
    let runningResultSubject = PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never>()

    let runningStateSubject = CurrentValueSubject<MotionType, Never>(.standing)
    var runningEventSubject = PassthroughSubject<RunningEvent, Never>()

    var goalSubscription: AnyCancellable?

    init(motionProvider: RunningMotionServiceable, dashBoard: RunningDashBoardServiceable, recoder: RunningRecordServiceable) {
        dashBoardService = dashBoard
        recordService = recoder
        motionService = motionProvider

        dashBoard.runningStateSubject
            .sink { [weak self] in
                self?.recordService.addState($0)
            }
            .store(in: &cancellables)

        motionProvider.motionTypeSubject
            .receive(on: RunLoop.main)
            .filter { [weak self] _ in self?.autoStatable ?? false }
            .filter { [weak self] in $0 != self?.runningStateSubject.value }
            .sink { [weak self] in
                self?.runningStateSubject.send($0)
                switch $0 {
                case .running:
                    dashBoard.setState(isRunning: true)
                case .standing:
                    dashBoard.setState(isRunning: false)
                }
            }
            .store(in: &cancellables)
    }

    func start() {
        recordService.clear()
        dashBoardService.clear()

        isRunning = true
        startTime = Date()
        autoStatable = true

        dashBoardService.start()
        motionService.start()

        runningEventSubject.send(.start)
    }

    func stop() {
        let endTime = Date()

        dashBoardService.stop()

        isRunning = false

        let activityInfo = recordService.save(startTime: startTime, endTime: endTime)
        runningResultSubject.send(activityInfo)
        runningEventSubject.send(.stop)
    }

    func pause() {
        autoStatable = false

        dashBoardService.setState(isRunning: false)
        runningEventSubject.send(.pause)
    }

    func resume() {
        autoStatable = true

        dashBoardService.setState(isRunning: true)
        runningEventSubject.send(.resume)
    }

    func setGoal(_ goalInfo: GoalInfo?) {
        guard let goalInfo = goalInfo else { return }

        switch goalInfo.type {
        case .distance:
            guard var value = Double(goalInfo.value) else { return }
            value *= 1000
            goalSubscription = dashBoardService.runningStateSubject
                .first(where: { $0.distance > value })
                .sink { [weak self] _ in
                    let text = "Congratulations. You've reached your goal of \(value) meters. Great job"
                    self?.runningEventSubject.send(.goal(text))
                }

        case .time:
            let components = goalInfo.value.components(separatedBy: ":")
            guard
                components.count >= 2,
                let hour = Int(components[0]),
                let minute = Int(components[1])
            else { return }
            let interval = hour * 60 * 60 + minute * 60
            goalSubscription = dashBoardService.runningTime
                .first(where: { $0 > Double(interval) })
                .sink { [weak self] _ in
                    let text = "Congratulations. You've reached your goal of running \(hour * 60 + minute) minutes. Kudos to you, friend."
                    self?.runningEventSubject.send(.goal(text))
                }

        case .none, .speed:
            return
        }
    }
}
