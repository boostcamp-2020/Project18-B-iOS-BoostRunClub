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
    var cancellables = Set<AnyCancellable>()

    init(
        motionDataModelProvider: MotionDataModelProvidable,
        motionActivityProvider: MotionActivityProvidable,
        locationProvider: LocationProvidable
    ) {
        self.motionDataModelProvider = motionDataModelProvider
        self.motionActivityProvider = motionActivityProvider
        self.locationProvider = locationProvider
    }

    func start() {
        bindProvider()
    }

    private func bindProvider() {
//        motionActivityProvider.currentMotionType
//        motionDataModelProvider.motionType
//        locationProvider.locationSubject
    }

    func stop() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
