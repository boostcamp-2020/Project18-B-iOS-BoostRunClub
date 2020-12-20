//
//  ServiceProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Foundation

class DependencyFactory {
    static let shared = DependencyFactory()

    // Service For Storage
    lazy var defaultsProvider = DefaultsProvider()
    lazy var coreDataService = CoreDataService()
    lazy var activityStorageService = ActivityStorageService(coreDataService: coreDataService)

    // Provider For RunningService
    lazy var locationProvider = LocationProvider()
    lazy var pedometerProvider = PedometerProvider()
    lazy var motionDataModelProvider = MotionDataModelProvider()
    lazy var runningSnapShotProvider = RunningSnapShotProvider()

    // Running Service
    lazy var runningDataService = RunningService(
        motionProvider: runningMotionService,
        dashBoard: runningDashBoardService,
        recoder: runningRecordService
    )
    lazy var runningMotionService = RunningMotionService(
        motionDataModelProvider: motionDataModelProvider,
        locationProvider: locationProvider
    )
    lazy var runningDashBoardService = RunningDashBoardService(
        eventTimer: EventTimeProvider(),
        locationProvider: locationProvider,
        pedometerProvider: pedometerProvider
    )
    lazy var runningRecordService = RunningRecordService(
        activityWriter: activityStorageService,
        mapSnapShotter: runningSnapShotProvider
    )
}
