//
//  EventTimeProvidable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

protocol EventTimeProvidable {
    var timeIntervalSubject: PassthroughSubject<TimeInterval, Never> { get }
    func start()
    func stop()
}
