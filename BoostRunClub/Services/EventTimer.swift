//
//  EventTimer.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/02.
//

import Combine
import Foundation

protocol EventTimerProtocol {
    var timeSubject: PassthroughSubject<TimeInterval, Never> { get }
    func start()
    func stop()
}

class EventTimer: EventTimerProtocol {
    var timeSubject = PassthroughSubject<TimeInterval, Never>()

    var cancellable: AnyCancellable?

    func start() {
        cancellable = Timer.TimerPublisher(interval: 1, runLoop: RunLoop.main, mode: .default)
            .autoconnect()
            .sink { date in
                self.timeSubject.send(date.timeIntervalSinceReferenceDate)
            }
    }

    func stop() {
        cancellable?.cancel()
    }
}
