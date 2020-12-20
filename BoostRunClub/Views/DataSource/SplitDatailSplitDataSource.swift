//
//  SplitDatailSplitDataSource.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

struct SplitRow {
    let distance: Double
    let kilometer: String
    let avgPace: String
    let change: ValueChange?
    let elevation: String
}

class SplitDatailSplitDataSource: NSObject, UITableViewDataSource {
    var data = [SplitRow]()
    var totalDistance: Double = 0

    func update(_ data: [SplitRow]) {
        self.data = data
        totalDistance = data.reduce(into: Double(0)) { $0 += $1.distance }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SplitDatailSplitCell.identifier,
            for: indexPath
        )

        if let cell = cell as? SplitDatailSplitCell {
//            cell.kilometerLabel.text = data[indexPath.row].kilometer
            cell.kilometerLabel.text = indexPath.row < data.count - 1 ? "\(indexPath.row + 1)" : String(format: "%.2f", Double(Int(totalDistance) % 1000) / 1000)
            cell.paceLabel.text = data[indexPath.row].avgPace
            cell.changeLabel.applyChange(data[indexPath.row].change)
            cell.elevationLabel.text = data[indexPath.row].elevation
        }

        return cell
    }
}
