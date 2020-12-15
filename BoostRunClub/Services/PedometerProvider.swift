//
//  PedometerProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreMotion
import Foundation

protocol PedometerProvidable {
    func start()
    func stop()
    var cadence: CurrentValueSubject<Int, Never> { get }
}

final class PedometerProvider: PedometerProvidable {
    private let pedometer = CMPedometer()
    private(set) var cadence = CurrentValueSubject<Int, Never>(0)
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

            self.cadence.value = Int(truncating: cadence) * 60
        }
    }
}
