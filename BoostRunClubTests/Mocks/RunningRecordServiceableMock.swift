//
//  RunningRecordServiceableMock.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation
import Foundation

class RunningRecordServiceableMock: RunningRecordServiceable {
    func addState(_: RunningState) {}

    func save(startTime _: Date?, endTime _: Date?) -> (activity: Activity, detail: ActivityDetail)? {
        return nil
    }

    func clear() {}

    var locations: [CLLocation] = []
    var routes: [RunningSlice] = []
    var didAddSplitSignal = PassthroughSubject<RunningSplit, Never>()
}
