//
//  MotionClassifier.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/19.
//

import Combine
import CoreMotion
import Foundation

class RunningMotionService: RunningMotionServiceable {
    private var motionDataModelProvider: MotionDataModelProvidable
    private var locationProvider: LocationProvidable

    var motionTypeSubject = PassthroughSubject<MotionType, Never>()
    var cancellables = Set<AnyCancellable>()

    init(
        motionDataModelProvider: MotionDataModelProvidable,
        locationProvider: LocationProvidable
    ) {
        self.motionDataModelProvider = motionDataModelProvider
        self.locationProvider = locationProvider
    }

    func start() {
        bindProvider()
        motionDataModelProvider.start()
    }

    private func bindProvider() {
        motionDataModelProvider.motionTypeSubject
            .receive(on: RunLoop.main)
            .sink {
                self.motionTypeSubject.send($0)
            }
            .store(in: &cancellables)

//        locationProvider.locationSubject
    }

    func stop() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
