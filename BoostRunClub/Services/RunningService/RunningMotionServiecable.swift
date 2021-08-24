//
//  RunningMotionServicable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import Foundation

protocol RunningMotionServiceable {
    var motionTypeSubject: PassthroughSubject<MotionType, Never> { get }
    func start()
    func stop()
}
