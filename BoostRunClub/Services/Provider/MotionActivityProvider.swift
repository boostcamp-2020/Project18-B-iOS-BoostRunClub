//
//  MotionActivityProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/19.
//

import Combine
import CoreMotion
import Foundation

protocol MotionActivityProvidable {
    func start()
    func stop()
}

class MotionActivityProvider: MotionActivityProvidable {
    private let activityManager = CMMotionActivityManager()
    private var isActive = false

    var currentMotionType = PassthroughSubject<MotionType, Never>()

    func startTrackingActivityType() {
        if isActive { return }

        isActive = true

        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (activity: CMMotionActivity?) in
            guard
                let self = self,
                let activity = activity
            else { return }

            let motionType = activity.motionType
            self.currentMotionType.send(motionType)
        }
    }

    func start() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
    }

    func stop() {
        activityManager.stopActivityUpdates()
        isActive = false
    }
}

extension CMMotionActivity {
    var motionType: MotionType {
        if stationary {
            return .standing
        } else if walking {
            return .running
        } else if running {
            return .running
        } else if cycling {
            return .running
        } else if automotive {
            return .running
        }
        return .standing
    }
}
