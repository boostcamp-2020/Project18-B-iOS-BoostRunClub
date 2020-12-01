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
    var locations = [CLLocation()]

    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    @Published var runningTime: TimeInterval = 0
    @Published var lastUpdatedTime: TimeInterval = 0

    var elapsedTime: AnyPublisher<TimeInterval, Never> {
        $lastUpdatedTime
            .map { $0 - self.startTime }
            .eraseToAnyPublisher()
    }

    var isRunning: Bool = false

    init() {
        cancellable = locationProvider.locationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] locations in
                guard
                    let self = self,
                    let location = locations.last
                else { return }

                let currentTime = location.timestamp.timeIntervalSinceReferenceDate
                if self.isRunning {
                    self.runningTime += currentTime - self.lastUpdatedTime
                }
                self.lastUpdatedTime = currentTime
            }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let currentTime = Date.timeIntervalSinceReferenceDate
            if self.isRunning {
                self.runningTime += currentTime - self.lastUpdatedTime
            }
            self.lastUpdatedTime = currentTime
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
}
