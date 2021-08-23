//
//  PedometerProviderMock.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

class PedometerProviderMock: PedometerProvidable {
    var isStarted = false

    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }

    var cadenceSubject = PassthroughSubject<Int, Never>()

    func send(_ cadence: Int) {
        cadenceSubject.send(cadence)
    }
}
