//
//  ActivityDetailDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/13.
//

import UIKit

class ActivityDetailDataSource: NSObject, UITableViewDataSource {
    private var maxPace: CGFloat = 0
    private var splits = [RunningSplit]()

    func loadData(_ splits: [RunningSplit]) {
        self.splits = splits
        maxPace = splits.reduce(into: 0) { $0 = max($0, CGFloat($1.avgPace)) }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if splits.isEmpty {
            return 0
        } else {
            return splits.count + 1
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SimpleSplitViewCell()
        if indexPath.row == 0 {
            cell.configure(style: .desc)
        } else {
            let idx = indexPath.row - 1
            let split = splits[idx]

            let distanceText = String(format: "%.2f", split.distance / 1000)
            let paceText = String(format: "%d'%d\"", split.avgPace / 60, split.avgPace % 60)
            let elevationText = String(split.elevation)

            let paceRatio = maxPace == 0 ? 0 : (maxPace - CGFloat(split.avgPace)) / maxPace

            cell.configure(
                style: .value,
                distance: distanceText,
                pace: paceText,
                elevation: elevationText,
                paceRatio: paceRatio
            )
        }
        return cell
    }
}
