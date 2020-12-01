//
//  RunningDataProvider.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/01.
//

import Combine
import CoreLocation
import Foundation

class RunningDataProvider {
    let locationProvider: LocationProvidable = LocationProvider.shared

    var timer: Timer?
    var cancellable: AnyCancellable?
    var locations: [CLLocation] = []

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    @Published var runningTime: TimeInterval = 0
    @Published var lastUpdatedTime: TimeInterval = 0
    @Published var distance: Double = 0
    @Published var pace: Int = 0
    @Published var totalPace: Int = 0

    var elapsedTime: AnyPublisher<TimeInterval, Never> {
        $lastUpdatedTime
            .map { $0 - self.startTime }
            .eraseToAnyPublisher()
    }

    var distancePublisher: AnyPublisher<Int, Never> {
        $distance
            .map { Int($0) }
            .eraseToAnyPublisher()
    }

    var avgPacePublisher: AnyPublisher<Int, Never> {
        $totalPace
            .drop(while: { _ -> Bool in
                self.locations.isEmpty
            })
            .map { $0 / self.locations.count }
            .eraseToAnyPublisher()
    }

    var isRunning: Bool = false

    init() {
        cancellable = locationProvider.locationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.updateLocation(location: location)
                self.updateTime(currentTime: location.timestamp.timeIntervalSinceReferenceDate)
            }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.updateTime(currentTime: Date.timeIntervalSinceReferenceDate)
        }
    }

    func start() {
        isRunning = true
        startTime = Date.timeIntervalSinceReferenceDate
        endTime = 0
        runningTime = 0
        lastUpdatedTime = startTime
        timer?.fire()
    }

    func updateTime(currentTime: TimeInterval) {
        if isRunning {
            runningTime += currentTime - lastUpdatedTime
        }
        lastUpdatedTime = currentTime
    }

    func updateLocation(location: CLLocation) {
        if let prevLocation = locations.last {
            distance += location.distance(from: prevLocation)
        }
        pace = Int(1000 / location.speed)

        locations.append(location)
        totalPace += pace
    }
}
