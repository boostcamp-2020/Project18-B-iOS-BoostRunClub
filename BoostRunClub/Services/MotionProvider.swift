//
//  MotionProvider.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Combine
import CoreMotion
import Foundation

final class MotionProvider {
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    private var isActive = false

    var currentMotionType = CurrentValueSubject<CMMotionActivity, Never>(.init())
    var cadence = CurrentValueSubject<Int, Never>(0)

    func startTrackingActivityType() {
        if isActive { return }

        isActive = true

        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity: CMMotionActivity?) in
            guard
                let self = self,
                let activity = activity
            else { return }

            self.currentMotionType.send(activity)
        }
    }

    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }

    func stopActivityUpdates() {
        activityManager.stopActivityUpdates()
        isActive = false
    }

    func startCountingSteps() {
        pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in

            guard
                let self = self,
                let cadence = pedometerData?.currentCadence,
                error == nil
            else { return }

            self.cadence.value = Int(truncating: cadence)
        }
    }
}

extension CMMotionActivity {
    var METFactor: Double {
        switch self {
        case _ where self.running :
            return 1.035
        case _ where self.walking:
            return 0.655
        case _ where self.cycling:
            return 0.450
        case _ where self.unknown:
            return 0
        default:
            return 0
        }
    }
}
