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
    lazy var activityProvider = ActivityProvider(coreDataService: coreDataService)
    lazy var locationProvider = LocationProvider()
    lazy var motionProvider = MotionProvider()
    lazy var pedometerProvider = PedometerProvider()
    lazy var runningDataService = RunningService(
        motionProvider: motionProvider,
        dashBoard: RunningDashBoard(
            eventTimer: EventTimer(),
            locationProvider: locationProvider,
            pedometerProvider: pedometerProvider
        ),
        recoder: RunningRecoder(
            activityWriter: activityProvider,
            mapSnapShotter: MapSnapShotService()
        )
    )
    lazy var defaultsProvider = DefaultsProvider()
}
