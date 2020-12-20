//
//  MotionDataModelProvidable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreML
import CoreMotion
import Foundation

protocol MotionDataModelProvidable {
    func start()
    func stop()
    var motionTypeSubject: PassthroughSubject<MotionType, Never> { get }
}
