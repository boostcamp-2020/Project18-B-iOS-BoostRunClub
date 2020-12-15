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

    var showProfileSignal: PassthroughSubject<Void, Never> { get }
    var showFilterSheetSignal: PassthroughSubject<FilterWithRange, Never> { get }
    var showActivityListScene: PassthroughSubject<Void, Never> { get }
    var showActivityDetailScene: PassthroughSubject<Activity, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    private var activities = [Activity]()
    private var ranges = [ActivityFilterType: [DateRange]]()
    var cancellables = Set<AnyCancellable>()

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider
        activityProvider.activityChangeSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.fetchActivities() }
            .store(in: &cancellables)

        fetchActivities()
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs
    func viewDidLoad() {
        didFilterChanged(to: 0)
    }

    func didFilterChanged(to idx: Int) {
        guard let filterType = ActivityFilterType(rawValue: idx) else { return }
        let ranges = getDateRanges(for: filterType)

        if let firstRange = ranges.first {
            let total = ActivityTotalConfig(
                filterType: filterType,
                filterRange: firstRange,
                activities: activities.filter { firstRange.contains(date: $0.createdAt) }
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

    func didSelectActivity(at index: Int) {
        guard recentActivitiesSubject.value.count > index else { return }
        showActivityDetailScene.send(recentActivitiesSubject.value[index])
    }

    func didTapShowAllActivities() {
        showActivityListScene.send()
    }

    func didTapShowProfileButton() {
        showProfileSignal.send()
    }

    func didTapShowDateFilter() {
        let ranges = getDateRanges(for: filterTypeSubject.value)
        showFilterSheetSignal.send((filterTypeSubject.value, ranges, totalDataSubject.value.selectedRange))
    }

    // Outputs
    var filterTypeSubject = CurrentValueSubject<ActivityFilterType, Never>(.week)
    var totalDataSubject = CurrentValueSubject<ActivityTotalConfig, Never>(ActivityTotalConfig())
    var recentActivitiesSubject = CurrentValueSubject<[Activity], Never>([])

    var showProfileSignal = PassthroughSubject<Void, Never>()
    var showFilterSheetSignal = PassthroughSubject<FilterWithRange, Never>()
    var showActivityListScene = PassthroughSubject<Void, Never>()
    var showActivityDetailScene = PassthroughSubject<Activity, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}

// MARK: - Private Functions

extension ActivityViewModel {
    private func fetchActivities() {
        activities = activityProvider.fetchActivities().sorted(by: >)

        ranges[filterTypeSubject.value] = filterTypeSubject.value.groupDateRanges(from: activities)

        let numRecentActivity = activities.count < 5 ? activities.count : 5
        if numRecentActivity > 0 {
            recentActivitiesSubject.send(activities[0 ..< numRecentActivity].map { $0 })
        }
    }

    private func getDateRanges(for filter: ActivityFilterType) -> [DateRange] {
        let ranges: [DateRange]
        if self.ranges.contains(where: { $0.key == filter }) {
            ranges = self.ranges[filter]!
        } else {
            ranges = filter.groupDateRanges(from: activities)
            self.ranges[filter] = ranges
        }
        return ranges
    }
}
