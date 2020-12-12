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
    lazy var mapSnapShotService = MapSnapShotService()
    lazy var runningDataProvider = RunningDataService(
        locationProvider: locationProvider,
        motionProvider: motionProvider,
        activityWriter: activityProvider,
        mapSnapShotService: mapSnapShotService
    )
    lazy var defaultsProvider = DefaultsProvider()
}
