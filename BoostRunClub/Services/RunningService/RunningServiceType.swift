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
}

class RunningService: RunningServiceType {
    private(set) var cancellables = Set<AnyCancellable>()
    private(set) var motionProvider: MotionProvider
    private(set) var dashBoard: RunningBoard
    private(set) var recoder: RunningRecodable

    private var startTime: Date?
    private var endTime: Date?

    private var autoStatable = true
    var isRunning = false
    let activityResults = PassthroughSubject<(activity: Activity, detail: ActivityDetail)?, Never>()

    let runningState = CurrentValueSubject<MotionType, Never>(.standing)
    var runningEvent = PassthroughSubject<RunningEvent, Never>()

    init(motionProvider: MotionProvider, dashBoard: RunningBoard, recoder: RunningRecodable) {
        self.dashBoard = dashBoard
        self.recoder = recoder
        self.motionProvider = motionProvider

        dashBoard.runningSubject
            .sink { [weak self] in
                self?.recoder.addState($0)
            }
            .store(in: &cancellables)

        motionProvider.currentMotionType
            .receive(on: RunLoop.main)
            .filter { [weak self] in $0 != self?.runningState.value }
            .filter { [weak self] _ in self?.autoStatable ?? false }
            .sink { [weak self] in
                switch $0 {
                case .running:
                    dashBoard.setState(isRunning: true)
                case .standing:
                    dashBoard.setState(isRunning: false)
                }
                self?.runningState.send($0)
            }
            .store(in: &cancellables)
    }

    func start() {
        startTime = Date()
        autoStatable = true
        dashBoard.start()
        motionProvider.startUpdating()
        isRunning = true
        runningEvent.send(.start)
    }

    func stop() {
        endTime = Date()
        dashBoard.stop()
        let activityInfo = recoder.save(startTime: startTime, endTime: endTime)
        activityResults.send(activityInfo)
        isRunning = false
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
}
