//
//  PedometerProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreMotion
import Foundation

final class PedometerProvider: PedometerProvidable {
    private let pedometer = CMPedometer()
    private(set) var cadenceSubject = PassthroughSubject<Int, Never>()
    private var isActive = false

    func start() {
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }

    func stop() {
        pedometer.stopUpdates()
    }

    func startCountingSteps() {
        if isActive { return }

        isActive = true

        pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in

            guard
                let self = self,
                let cadence = pedometerData?.currentCadence,
                error == nil
            else { return }

            self.cadenceSubject.send(Int(truncating: cadence) * 60)
        }
    }
}
