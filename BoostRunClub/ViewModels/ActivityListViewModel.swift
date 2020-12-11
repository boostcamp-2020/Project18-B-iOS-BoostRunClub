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
    func didTapActivity(section: Int, row: Int)
}

protocol ActivityListViewModelOutputs {
    var activityListItemSubject: CurrentValueSubject<[ActivityListItem], Never> { get }

    var showActivityDetails: PassthroughSubject<Activity, Never> { get }
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

    func didTapActivity(section: Int, row: Int) {
        let activity = activityListItemSubject.value[section].items[row]
        showActivityDetails.send(activity)
    }

    // Outputs
    var activityListItemSubject = CurrentValueSubject<[ActivityListItem], Never>([])

    var showActivityDetails = PassthroughSubject<Activity, Never>()
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
}

extension ActivityListViewModel: ActivityListViewModelTypes {
    var inputs: ActivityListViewModelInputs { self }
    var outputs: ActivityListViewModelOutputs { self }
}

// MARK: - Private Functions

extension ActivityListViewModel {
    private func makeActivityListItems(from data: [Activity]) -> [ActivityListItem] {
        let ranges = ActivityFilterType.month.groupDateRanges(from: data)
        var items = [[Activity]](repeating: [], count: ranges.count)
        data.forEach { activity in
            guard let idx = ranges.firstIndex(where: { $0.contains(date: activity.createdAt) })
            else { return }
            items[idx].append(activity)
        }

        return items.enumerated()
            .reduce(into: [ActivityListItem]()) {
                let index = $1.0
                let listItem = $1.1
                let total = ActivityTotalConfig(
                    filterType: .month,
                    filterRange: ranges[index],
                    activities: listItem
                )
                $0.append(ActivityListItem(total: total, items: listItem))
            }
            .sorted(by: { $0 > $1 })
    }
}
