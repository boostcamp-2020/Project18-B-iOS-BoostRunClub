//
//  MotionDataModelProvidableMock.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

class MotionDataModelProvidableMock: MotionDataModelProvidable {
    var isStarted = false

    func start() {
        isStarted = true
    }

    func stop() {
        isStarted = false
    }

    var motionTypeSubject = PassthroughSubject<MotionType, Never>()

    func send(_ motionType: MotionType) {
        motionTypeSubject.send(motionType)
    }
}
