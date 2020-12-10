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
    typealias FilterWithRange = (type: ActivityFilterType, ranges: [DateRange], current: DateRange)

    var filterTypeSubject: CurrentValueSubject<ActivityFilterType, Never> { get }
    var totalDataSubject: CurrentValueSubject<ActivityTotalConfig, Never> { get }
    var recentActivitiesSubject: CurrentValueSubject<[Activity], Never> { get }

    var showProfileScene: PassthroughSubject<Void, Never> { get }
    var showFilterSheetSignal: PassthroughSubject<FilterWithRange, Never> { get }
    var showActivityListScene: PassthroughSubject<Void, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    // ERASE!: DummyData
    let dummyActivity = [
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-21 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-22 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-23 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-10-24 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-10 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-11 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-11-12 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-08 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-09 13:00")!),
        Activity(date: DateFormatter.YMDHMFormatter.date(from: "2020-12-10 13:00")!),
    ]

    private var activities = [Activity]()
    private var ranges = [ActivityFilterType: [DateRange]]()

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider

        // ERASE! : dummy Data
        activities = dummyActivity

        let dates = activities.map { $0.createdAt }
        ranges[filterTypeSubject.value] = filterTypeSubject.value.groupDateRanges(from: dates)

        let numRecentActivity = activities.count < 5 ? activities.count : 5
        if numRecentActivity > 0 {
            recentActivitiesSubject.send(activities[0 ..< numRecentActivity].map { $0 })
        }
    }

    // Inputs
    func viewDidLoad() {
        didFilterChanged(to: 0)
    }

    func didFilterChanged(to idx: Int) {
        guard let filterType = ActivityFilterType(rawValue: idx) else { return }
        let ranges = getDateRanges(for: filterType)

        if let latestRange = ranges.last {
            let total = ActivityTotalConfig(
                filterType: filterType,
                filterRange: latestRange,
                activities: activities.filter { latestRange.contains(date: $0.createdAt) }
            )
            filterTypeSubject.send(filterType)
            totalDataSubject.send(total)
        }
    }

    func didFilterRangeChanged(range: DateRange) {
        let total = ActivityTotalConfig(
            filterType: filterTypeSubject.value,
            filterRange: range,
            activities: activities.filter { range.contains(date: $0.createdAt) }
        )
        totalDataSubject.send(total)
    }

    func didSelectActivity(at _: Int) {}

    func didTapShowAllActivities() {
        showActivityListScene.send()
    }

    func didTapShowProfileButton() {}

    func didTapShowDateFilter() {
        let ranges = getDateRanges(for: filterTypeSubject.value)
        showFilterSheetSignal.send((filterTypeSubject.value, ranges, totalDataSubject.value.selectedRange))
    }

    // Outputs
    var filterTypeSubject = CurrentValueSubject<ActivityFilterType, Never>(.week)
    var totalDataSubject = CurrentValueSubject<ActivityTotalConfig, Never>(ActivityTotalConfig())
    var recentActivitiesSubject = CurrentValueSubject<[Activity], Never>([])

    var showProfileScene = PassthroughSubject<Void, Never>()
    var showFilterSheetSignal = PassthroughSubject<FilterWithRange, Never>()
    var showActivityListScene = PassthroughSubject<Void, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}

// MARK: - Private Functions

extension ActivityViewModel {
    private func getDateRanges(for filter: ActivityFilterType) -> [DateRange] {
        let ranges: [DateRange]
        if self.ranges.contains(where: { $0.key == filter }) {
            ranges = self.ranges[filter]!
        } else {
            let dates = dummyActivity.compactMap { $0.createdAt }
            ranges = filter.groupDateRanges(from: dates)
            self.ranges[filter] = ranges
        }
        return ranges
    }
}
