//
//  RunningBoard.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreLocation
import Foundation

final class RunningDashBoardService: RunningDashBoardServiceable {
    private var eventTimer: EventTimeProvidable
    private var locationProvider: LocationProvidable
    private var pedometerProvider: PedometerProvidable

    private(set) var isRunning = false

    private var lastUpdatedTime: TimeInterval = 0
    private var numLocationReceive: Double = 0

    // runningTime, calorie, pace, cadence, distance
    private(set) var location: CLLocation?
    private(set) var runningTime = CurrentValueSubject<TimeInterval, Never>(0)
    private(set) var calorie: Double = 0
    private(set) var pace: Double = 0
    private(set) var cadence: Int = 0
    private(set) var distance: Double = 0
    private(set) var avgPace: Double = 0

    var runningStateSubject = PassthroughSubject<RunningState, Never>()
    var cancellables = Set<AnyCancellable>()

    init(eventTimer: EventTimeProvidable, locationProvider: LocationProvidable, pedometerProvider: PedometerProvidable) {
        self.eventTimer = eventTimer
        self.locationProvider = locationProvider
        self.pedometerProvider = pedometerProvider
    }

    func setState(isRunning: Bool) {
        self.isRunning = isRunning
    }

    func start() {
        bindEvent()
        eventTimer.start()
        locationProvider.startBackgroundTask()
        pedometerProvider.start()

        lastUpdatedTime = Date.timeIntervalSinceReferenceDate
        isRunning = true
    }

    private func bindEvent() {
        locationProvider.locationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.updateLocation(newLocation: location)
                self.updateTime(currentTime: location.timestamp.timeIntervalSinceReferenceDate)
            }
            .store(in: &cancellables)

        eventTimer.timeIntervalSubject
            .sink { [weak self] time in
                self?.updateTime(currentTime: time)
            }
            .store(in: &cancellables)

        pedometerProvider.cadenceSubject
            .sink { [weak self] cadence in
                self?.cadence = cadence
            }.store(in: &cancellables)
    }

    func clear() {
        lastUpdatedTime = 0
        location = nil
        runningTime.value = 0
        calorie = 0
        pace = 0
        cadence = 0
        distance = 0
        avgPace = 0
        numLocationReceive = 0
    }

    func stop() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        eventTimer.stop()
        locationProvider.stopBackgroundTask()
        pedometerProvider.stop()
    }

    private func updateTime(currentTime: TimeInterval) {
        if isRunning {
            runningTime.value += currentTime - lastUpdatedTime
        }
        lastUpdatedTime = currentTime
    }

    private func publish() {
        guard let location = location else { return }
        print("[DASHBOARD] D: \(distance)")
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
        runningStateSubject.send(result)
    }

    private func updateLocation(newLocation: CLLocation) {
        numLocationReceive += 1
        // processing distance
        if isRunning, let prevLocation = location {
            let addedDistance = prevLocation.distance(from: newLocation)
            let newDistance = addedDistance + distance

            //    킬로미터 * Motion상수 * weight
            calorie += addedDistance / 1000 * MotionType.running.METFactor * 70

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
