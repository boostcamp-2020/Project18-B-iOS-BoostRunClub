//
//  ActivityDetailDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/13.
//

import UIKit

class ActivityDetailDataSource: NSObject, UITableViewDataSource {
    private var maxPace: CGFloat = 0
    private var minPace: CGFloat = 0
    private var splits = [RunningSplit]()
    private var totalDistance: Double = 0

    func loadData(splits: [RunningSplit], distance: Double) {
        self.splits = splits
        totalDistance = distance
        let minMaxValue = splits.reduce(into: (min: CGFloat.infinity, max: CGFloat(0))) {
            let value = CGFloat($1.avgPace)
            $0.max = max($0.max, value)
            $0.min = min($0.min, value)
        }
        maxPace = minMaxValue.max
        minPace = minMaxValue.min
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if splits.isEmpty {
            return 0
        } else {
            return splits.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SimpleSplitViewCell.self)", for: indexPath)

        if let cell = cell as? SimpleSplitViewCell {
            switch indexPath.row {
            case 0:
                cell.configure(style: .description)
            default:
                let idx = indexPath.row - 1
                let split = splits[idx]

                let distanceText: String
                if idx < splits.count - 1 {
                    distanceText = "\(idx + 1)"
                } else {
                    distanceText = String(format: "%.2f", Double(Int(totalDistance) % 1000) / 1000)
                }

                let paceText = String(format: "%d'%d\"", split.avgPace / 60, split.avgPace % 60)
                let elevationText = String(split.elevation)

                let paceRatio: CGFloat
                if maxPace - minPace > 0 {
                    paceRatio = (maxPace - CGFloat(split.avgPace)) / (maxPace - minPace)
                } else {
                    paceRatio = 0
                }

                cell.configure(
                    style: .value,
                    distance: distanceText,
                    pace: paceText,
                    elevation: elevationText,
                    paceRatio: paceRatio
                )
            }
        }

        return cell
    }
}
