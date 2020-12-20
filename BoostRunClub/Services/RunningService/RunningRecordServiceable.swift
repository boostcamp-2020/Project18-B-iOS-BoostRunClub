//
//  RunningRecordServicable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation
import Foundation

protocol RunningRecordServiceable {
    func addState(_ state: RunningState)
    func save(startTime: Date?, endTime: Date?) -> (activity: Activity, detail: ActivityDetail)?
    func clear()

    var locations: [CLLocation] { get }
    var routes: [RunningSlice] { get }
    var didAddSplitSignal: PassthroughSubject<RunningSplit, Never> { get }
}
