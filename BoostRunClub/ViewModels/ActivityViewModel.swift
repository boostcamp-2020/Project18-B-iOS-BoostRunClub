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
    func viewDidLoad()
    func didFilterChanged(to idx: Int)
    func didFilterRangeChanged(range: DateRange)
    func didSelectActivity(at index: Int)
    func didTapShowDateFilter()
    func didTapShowAllActivities()
    func didTapShowProfileButton()
}

protocol ActivityViewModelOutputs {
    typealias FilterWithRange = (type: ActivityFilterType, ranges: [DateRange])

    var activityFilterType: CurrentValueSubject<ActivityFilterType, Never> { get }
    var activityTotal: CurrentValueSubject<ActivityTotalConfig, Never> { get }
    var activities: CurrentValueSubject<[Activity], Never> { get }

    var showProfileScene: PassthroughSubject<Void, Never> { get }
    var showFilterSheetSignal: PassthroughSubject<FilterWithRange, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    // DummyData
    let dummyActivity = [
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-21 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-22 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-23 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-24 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-10 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-11 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-12 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-08 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-09 13:00")),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-10 13:00")),
    ]

    private var ranges = [ActivityFilterType: [DateRange]]()

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider

        let dates = dummyActivity.compactMap { $0.createdAt }
        ranges[activityFilterType.value] = activityFilterType.value.groupDateRanges(from: dates)

        activities.send(dummyActivity)
    }

    // Inputs
    func viewDidLoad() {
        didFilterChanged(to: 0)
    }

    func didFilterChanged(to idx: Int) {
        guard let filterType = ActivityFilterType(rawValue: idx) else { return }
        let dates = dummyActivity.compactMap { $0.createdAt }
        let ranges = self.ranges[filterType] ?? filterType.groupDateRanges(from: dates)
        if let latestRange = ranges.last {
            let total = ActivityTotalConfig(
                filterType: filterType,
                filterRange: latestRange,
                activities: dummyActivity.filter {
                    guard let createdAt = $0.createdAt else { return false }
                    return latestRange.contains(date: createdAt)
                }
            )
            activityTotal.send(total)
        }

        self.ranges[filterType] = ranges
    }

    func didFilterRangeChanged(range: DateRange) {
        let total = ActivityTotalConfig(
            filterType: activityFilterType.value,
            filterRange: range,
            activities: dummyActivity.filter {
                guard let createdAt = $0.createdAt else { return false }
                return range.contains(date: createdAt)
            }
        )
        activityTotal.send(total)
    }

    func didSelectActivity(at _: Int) {}

    func didTapShowAllActivities() {}

    func didTapShowProfileButton() {}

    func didTapShowDateFilter() {
        let filterType = activityFilterType.value
        let ranges = self.ranges[filterType] ?? filterType.groupDateRanges(from: dummyActivity.compactMap { $0.createdAt })
        showFilterSheetSignal.send((filterType, ranges))
        self.ranges[filterType] = ranges
    }

    // Outputs
    var activityFilterType = CurrentValueSubject<ActivityFilterType, Never>(.week)
    var activityTotal = CurrentValueSubject<ActivityTotalConfig, Never>(ActivityTotalConfig())
    var activities = CurrentValueSubject<[Activity], Never>([])

    var showProfileScene = PassthroughSubject<Void, Never>()
    var showFilterSheetSignal = PassthroughSubject<FilterWithRange, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}
