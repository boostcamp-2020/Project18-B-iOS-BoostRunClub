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
    var dashBoard: RunningBoard { get }
    var recoder: RunningRecodable { get }
    var activityResults: PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never> { get }
    var runningState: CurrentValueSubject<MotionType, Never> { get }
    var runningEvent: PassthroughSubject<RunningEvent, Never> { get }
    var isRunning: Bool { get }

    func start()
    func stop()
    func pause()
    func resume()

    func setGoal(_ goalInfo: GoalInfo?)
}

class RunningService: RunningServiceType {
    private(set) var cancellables = Set<AnyCancellable>()
    private(set) var motionProvider: MotionProvidable
    private(set) var dashBoard: RunningBoard
    private(set) var recoder: RunningRecodable

    private var startTime: Date?

    private var autoStatable = true
    var isRunning = false
    let activityResults = PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never>()

    let runningState = CurrentValueSubject<MotionType, Never>(.standing)
    var runningEvent = PassthroughSubject<RunningEvent, Never>()

    var goalSubscription: AnyCancellable?

    init(motionProvider: MotionProvidable, dashBoard: RunningBoard, recoder: RunningRecodable) {
        self.dashBoard = dashBoard
        self.recoder = recoder
        self.motionProvider = motionProvider

        dashBoard.runningSubject
            .sink { [weak self] in
                self?.recoder.addState($0)
            }
            .store(in: &cancellables)

        motionProvider.motionType
            .debounce(for: 3, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .filter { [weak self] _ in self?.autoStatable ?? false }
            .filter { [weak self] in $0 != self?.runningState.value }
            .sink { [weak self] in

                self?.runningState.send($0)
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
        recoder.clear()
        dashBoard.clear()

        isRunning = true
        startTime = Date()
        autoStatable = true

        dashBoard.start()
        motionProvider.start()

        runningEvent.send(.start)
    }

    func stop() {
        let endTime = Date()

        dashBoard.stop()

        isRunning = false

        let activityInfo = recoder.save(startTime: startTime, endTime: endTime)
        activityResults.send(activityInfo)
        runningEvent.send(.stop)
    }

    func pause() {
        autoStatable = false

        dashBoard.setState(isRunning: false)
        runningEvent.send(.pause)
    }

    func resume() {
        autoStatable = true

        dashBoard.setState(isRunning: true)
        runningEvent.send(.resume)
    }

    func setGoal(_ goalInfo: GoalInfo?) {
        guard let goalInfo = goalInfo else { return }

        switch goalInfo.type {
        case .distance:
            guard var value = Double(goalInfo.value) else { return }
            value *= 1000
            goalSubscription = dashBoard.runningSubject
                .first(where: { $0.distance > value })
                .sink { [weak self] _ in
                    let text = "Congratulations. You've reached your goal of \(value) meters. Great job"
                    self?.runningEvent.send(.goal(text))
                }

        case .time:
            let components = goalInfo.value.components(separatedBy: ":")
            guard
                components.count >= 2,
                let hour = Int(components[0]),
                let minute = Int(components[1])
            else { return }
            let interval = hour * 60 * 60 + minute * 60
            goalSubscription = dashBoard.runningTime
                .first(where: { $0 > Double(interval) })
                .sink { [weak self] _ in
                    let text = "Congratulations. You've reached your goal of running \(hour * 60 + minute) minutes. Kudos to you, friend."
                    self?.runningEvent.send(.goal(text))
                }

        case .none, .speed:
            return
        }
    }
}
