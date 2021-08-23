//
//  ActivityDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivityDataSource: NSObject {
    private(set) var activities = [Activity]()
    private(set) var statisticHeaderTitle = ""
    private(set) var activityTotal = ActivityTotalConfig()

    private(set) lazy var containerCellView = ActivitiesContainerCellView()
    private var activityStatisticCells: [ActivityStatisticCellView] = [
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
    ]

    func loadActivities(_ activities: [Activity]) {
        self.activities = activities
    }

    func loadActivityTotal(_ config: ActivityTotalConfig) {
        switch config.filterType {
        case .week, .month:
            statisticHeaderTitle = ""
        case .all, .year:
            statisticHeaderTitle = config.filterType == .all ? "총 활동 통계" : config.period + " 통계"
        }

        activityStatisticCells[0].configure(title: "러닝", value: config.numRunningPerWeekText)
        activityStatisticCells[1].configure(title: "킬로미터", value: config.distancePerRunningText)
        activityStatisticCells[2].configure(title: "러닝페이스", value: config.avgPaceText)
        activityStatisticCells[3].configure(title: "시간", value: config.runningTimePerRunningText)
        activityStatisticCells[4].configure(title: "고도 상승", value: config.totalElevationText)
    }
}

// MARK: - UICollectionViewDataSource Implementation

extension ActivityDataSource: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return activities.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(ActivityCellView.self)",
            for: indexPath
        ) as? ActivityCellView
        cell?.configure(with: activities[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UITableViewDataSource Implementation

extension ActivityDataSource: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        statisticHeaderTitle.isEmpty ? 1 : 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statisticHeaderTitle.isEmpty {
            return 1
        } else {
            return section == 0 ? 5 : 1
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !statisticHeaderTitle.isEmpty,
           indexPath.section == 0
        {
            return activityStatisticCells[indexPath.row]
        } else {
            return containerCellView
        }
    }
}
