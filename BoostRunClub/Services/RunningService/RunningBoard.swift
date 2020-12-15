//
//  RunningBoard.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreLocation
import Foundation

protocol RunningBoard {
    func setState(isRunning: Bool)
    var runningSubject: PassthroughSubject<RunningState, Never> { get }
    var runningTime: CurrentValueSubject<TimeInterval, Never> { get }

    var location: CLLocation? { get }
    var calorie: Int { get }
    var pace: Double { get }
    var cadence: Int { get }
    var distance: Double { get }
    var avgPace: Double { get }

    func start()
    func stop()
}

class RunningDashBoard: RunningBoard {
    private var eventTimer: EventTimerProtocol
    private var locationProvider: LocationProvidable
    private var pedometerProvider: PedometerProvidable

    func setState(isRunning: Bool) {
        self.isRunning = isRunning
    }

    private(set) var isRunning = false

    private var lastUpdatedTime: TimeInterval = 0

    // runningTime, calorie, pace, cadence, distance
    private(set) var location: CLLocation?
    private(set) var runningTime = CurrentValueSubject<TimeInterval, Never>(0)
    private(set) var calorie: Int = 0
    private(set) var pace: Double = 0
    private(set) var cadence: Int = 0
    private(set) var distance: Double = 0
    private(set) var avgPace: Double = 0

    var runningSubject = PassthroughSubject<RunningState, Never>()
    var cancellables = Set<AnyCancellable>()

    init(eventTimer: EventTimerProtocol, locationProvider: LocationProvidable, pedometerProvider: PedometerProvidable) {
        self.eventTimer = eventTimer
        self.locationProvider = locationProvider
        self.pedometerProvider = pedometerProvider

        locationProvider.locationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.updateLocation(newLocation: location)
                self.updateTime(currentTime: location.timestamp.timeIntervalSinceReferenceDate)
            }
            .store(in: &cancellables)

        eventTimer.timeSubject
            .sink { [weak self] time in
                self?.updateTime(currentTime: time)
            }
            .store(in: &cancellables)

        pedometerProvider.cadence
            .sink { [weak self] cadence in
                self?.cadence = cadence
            }.store(in: &cancellables)
    }

    func start() {
        clear()
        eventTimer.start()
        locationProvider.startBackgroundTask()
        pedometerProvider.start()
        lastUpdatedTime = Date.timeIntervalSinceReferenceDate
        isRunning = true
    }

    private func clear() {
        lastUpdatedTime = 0
        location = nil
        runningTime.value = 0
        calorie = 0
        pace = 0
        cadence = 0
        distance = 0
        avgPace = 0
    }

    func stop() {
        eventTimer.stop()
        locationProvider.stopBackgroundTask()
        pedometerProvider.stop()
    }

    func updateTime(currentTime: TimeInterval) {
        if isRunning {
            runningTime.value += currentTime - lastUpdatedTime
        }
        lastUpdatedTime = currentTime
    }

    func publish() {
        guard let location = location else { return }

        let result = RunningState(
            location: location,
            runningTime: runningTime.value,
            calorie: calorie,
            pace: Int(pace),
            avgPace: Int(avgPace),
            cadence: cadence,
            distance: distance,
            isRunning: isRunning
        )
        runningSubject.send(result)
    }

    private var numLocationReceive: Double = 0
    func updateLocation(newLocation: CLLocation) {
        numLocationReceive += 1
        // processing distance
        if isRunning, let prevLocation = location {
            let addedDistance = prevLocation.distance(from: newLocation)
            let newDistance = addedDistance + distance

            //    킬로미터 * Motion상수 * weight
            calorie += Int(addedDistance / 1000 * MotionType.running.METFactor * 70)

            distance = newDistance
        }

        // processing pace
        let paceDouble = 1000 / newLocation.speed
        if !(paceDouble.isNaN || paceDouble.isInfinite) {
            pace = paceDouble
        }

        avgPace = (avgPace * (numLocationReceive - 1) + pace) / numLocationReceive

        location = newLocation
        publish()
    }
}
