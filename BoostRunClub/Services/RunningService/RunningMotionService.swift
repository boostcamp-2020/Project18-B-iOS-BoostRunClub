//
//  MotionClassifier.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/19.
//

import Combine
import CoreMotion
import Foundation

protocol RunningMotionServiceable {
    var motionTypeSubject: PassthroughSubject<MotionType, Never> { get }
    func start()
    func stop()
}

class RunningMotionService: RunningMotionServiceable {
    private var motionDataModelProvider: MotionDataModelProvidable
    private var locationProvider: LocationProvidable
    private var motionActivityProvider: MotionActivityProvidable

    var motionTypeSubject = PassthroughSubject<MotionType, Never>()

    init(
        motionDataModelProvider: MotionDataModelProvidable,
        motionActivityProvider: MotionActivityProvidable,
        locationProvider: LocationProvidable
    ) {
        self.motionDataModelProvider = motionDataModelProvider
        self.motionActivityProvider = motionActivityProvider
        self.locationProvider = locationProvider
    }

    func start() {}

    func stop() {}
}
