//
//  ActivityListViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Combine
import Foundation

protocol ActivityListViewModelTypes {
    var inputs: ActivityListViewModelInputs { get }
    var outputs: ActivityListViewModelOutputs { get }
}

protocol ActivityListViewModelInputs {
    func didTapBackItem()
}

protocol ActivityListViewModelOutputs {
    var activityListItemSubject: CurrentValueSubject<[ActivityListItem], Never> { get }

    var showActivityDetails: PassthroughSubject<UUID, Never> { get }
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityListViewModel: ActivityListViewModelInputs, ActivityListViewModelOutputs {
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

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider

        // ERASE!: DummyData
        let listItems = makeActivityListItems(from: dummyActivity)
        activityListItemSubject.send(listItems)
    }

    // Inputs
    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    // Outputs
    var activityListItemSubject = CurrentValueSubject<[ActivityListItem], Never>([])

    var showActivityDetails = PassthroughSubject<UUID, Never>()
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
}

extension ActivityListViewModel: ActivityListViewModelTypes {
    var inputs: ActivityListViewModelInputs { self }
    var outputs: ActivityListViewModelOutputs { self }
}

// MARK: - Private Functions

extension ActivityListViewModel {
    private func makeActivityListItems(from data: [Activity]) -> [ActivityListItem] {
        let dates = data.map { $0.createdAt }
        let ranges = ActivityFilterType.month.groupDateRanges(from: dates)
        var items = [[Activity]](repeating: [], count: ranges.count)
        data.forEach { activity in
            guard let idx = ranges.firstIndex(where: { $0.contains(date: activity.createdAt) })
            else { return }
            items[idx].append(activity)
        }

        var results = [ActivityListItem]()
        for (idx, item) in items.enumerated() {
            let total = ActivityTotalConfig(filterType: .month, filterRange: ranges[idx], activities: item)
            results.append(ActivityListItem(total: total, items: item))
        }

        return results.sorted(by: { $0.total.totalRange.start > $1.total.totalRange.start })
    }
}
