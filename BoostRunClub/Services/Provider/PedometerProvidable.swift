//
//  PedometerProvidable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreMotion
import Foundation

protocol PedometerProvidable {
    func start()
    func stop()
    var cadenceSubject: PassthroughSubject<Int, Never> { get }
}
