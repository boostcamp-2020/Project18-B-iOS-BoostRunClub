//
//  RunningDashBoardServicable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation
import Foundation

protocol RunningDashBoardServiceable {
    var runningStateSubject: PassthroughSubject<RunningState, Never> { get }
    var runningTime: CurrentValueSubject<TimeInterval, Never> { get }

    var location: CLLocation? { get }
    var calorie: Double { get }
    var pace: Double { get }
    var cadence: Int { get }
    var distance: Double { get }
    var avgPace: Double { get }

    func setState(isRunning: Bool)
    func start()
    func stop()
    func clear()
}
