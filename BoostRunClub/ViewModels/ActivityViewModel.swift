//
//  ActivityViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

import Combine

protocol ActivityViewModelTypes: AnyObject {
    var inputs: ActivityViewModelInputs { get }
    var outputs: ActivityViewModelOutputs { get }
}

protocol ActivityViewModelInputs {
    func didFilterChanged(to idx: Int)
    func didFilterRangeChanged(from startDate: Date, to endDate: Date)
    func didSelectActivity(at index: Int)
    func didTapShowDateFilter()
    func didTapShowAllActivities()
    func didTapShowProfileButton()
}

protocol ActivityViewModelOutputs {
    var activityTotal: CurrentValueSubject<ActivityTotalConfig, Never> { get }
    var activityStatistic: CurrentValueSubject<ActivityStatisticConfig, Never> { get }
    var activitiesSubject: CurrentValueSubject<[Activity], Never> { get }

    var showStatisticSignal: PassthroughSubject<ActivityStatisticConfig?, Never> { get }
    var showProfileScene: PassthroughSubject<Void, Never> { get }
    var showFilterSheetSignal: PassthroughSubject<ActivityFilterType, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    // DummyData
    let dummyActivity = [
        Activity(avgPace: 1300, distance: 3300, duration: 10000, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 1600, distance: 5300, duration: 23410, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 1234, distance: 3353, duration: 1230, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 1129, distance: 2023, duration: 3304, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 3033, distance: 44000, duration: 2222, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 0933, distance: 11342, duration: 3034, thumbnail: nil, createdAt: nil, uuid: nil),
        Activity(avgPace: 0822, distance: 2348, duration: 0035, thumbnail: nil, createdAt: nil, uuid: nil),
    ]

    let dummyTotal = ActivityTotalConfig(filterType: .week, period: "이번주", distance: 1258, numRunning: 5, avgPace: 1382, runningTime: 5843)

    let dummyStatistic = ActivityStatisticConfig(filterType: .week, period: "2020년 통계", distance: 1258, numRunning: 30, avgPace: 2259, runningTime: 8302, elevation: 882)

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider

        activityTotal.send(dummyTotal)
        activityStatistic.send(dummyStatistic)
        let activities: [Activity] = (1 ... 5).compactMap {
            if $0 < self.dummyActivity.count {
                return dummyActivity[$0]
            }
            return nil
        }
        activitiesSubject.send(activities)
    }

    // Inputs
    func didFilterChanged(to _: Int) {}
    func didFilterRangeChanged(from _: Date, to _: Date) {}
    func didSelectActivity(at _: Int) {}
    func didTapShowAllActivities() {}
    func didTapShowProfileButton() {}
    func didTapShowDateFilter() {
        showFilterSheetSignal.send(activityTotal.value.filterType)
    }

    // Outputs
    var activityTotal = CurrentValueSubject<ActivityTotalConfig, Never>(ActivityTotalConfig())
    var activityStatistic = CurrentValueSubject<ActivityStatisticConfig, Never>(ActivityStatisticConfig())
    var activitiesSubject = CurrentValueSubject<[Activity], Never>([])

    var showStatisticSignal = PassthroughSubject<ActivityStatisticConfig?, Never>()
    var showProfileScene = PassthroughSubject<Void, Never>()
    var showFilterSheetSignal = PassthroughSubject<ActivityFilterType, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}
