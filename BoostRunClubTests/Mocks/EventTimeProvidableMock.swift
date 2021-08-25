//
//  EventTimeProvidableMock.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

class EventTimeProvidableMock: EventTimeProvidable {
    var isStarted = false

    var timeIntervalSubject = PassthroughSubject<TimeInterval, Never>()

    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }

    func send(_ interval: Double) {
        timeIntervalSubject.send(interval)
    }
}
