//
//  ServiceProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Foundation

class DependencyFactory {
    static let shared = DependencyFactory()
    lazy var coreDataService = CoreDataService()
    lazy var activityStorage = ActivityStorageService(coreDataService: coreDataService)
    lazy var locationProvider = LocationProvider()
    lazy var pedometerProvider = PedometerProvider()
    lazy var defaultsProvider = DefaultsProvider()

    lazy var motionDataModelProvider = MotionDataModelProvider()
    lazy var motionActivityProvider = MotionActivityProvider()
    lazy var runningSnapShotProvider = RunningSnapShotProvider()

    // Running Service
    lazy var runningDataService = RunningService(
        motionProvider: RunningMotionService(
            motionDataModelProvider: motionDataModelProvider,
            motionActivityProvider: motionActivityProvider,
            locationProvider: locationProvider
        ),
        dashBoard: RunningDashBoardService(
            eventTimer: EventTimeProvider(),
            locationProvider: locationProvider,
            pedometerProvider: pedometerProvider
        ),
        recoder: RunningRecordService(
            activityWriter: activityStorage,
            mapSnapShotter: runningSnapShotProvider
        )
    )
}
