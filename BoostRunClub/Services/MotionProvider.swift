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

    var currentMotionType = CurrentValueSubject<MotionType, Never>(MotionType.unknown)
    var cadence = CurrentValueSubject<Int, Never>(0)

    func startTrackingActivityType() {
        if isActive { return }

        isActive = true

        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in

            guard
                let self = self,
                let activity = activity
            else { return }

            let motionType = activity.motionType

            if self.currentMotionType.value != motionType {
                self.currentMotionType.send(motionType)
            }
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
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in

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
    var motionType: MotionType {
        if stationary {
            return .stationary
        } else if walking {
            return .walking
        } else if running {
            return .running
        } else if cycling {
            return .cycling
        } else if automotive {
            return .automotive
        }
        return .unknown
    }
}
