//
//  EventTimer.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/02.
//

import Combine
import Foundation

class EventTimeProvider: EventTimeProvidable {
    var timeIntervalSubject = PassthroughSubject<TimeInterval, Never>()

    private var cancellable: AnyCancellable?

    func start() {
        cancellable = Timer.TimerPublisher(interval: 0.8, runLoop: RunLoop.main, mode: .common)
            .autoconnect()
            .sink { date in
                self.timeIntervalSubject.send(date.timeIntervalSinceReferenceDate)
            }
    }

    func stop() {
        cancellable?.cancel()
    }
}
