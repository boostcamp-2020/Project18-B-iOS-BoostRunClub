//
//  SplitDatailSplitDataSource.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

struct SplitRow {
    let kilometer: String
    let avgPace: String
    let change: ValueChange?
    let elevation: String
}

class SplitDatailSplitDataSource: NSObject, UITableViewDataSource {
    var data = [SplitRow]()

    func update(_ data: [SplitRow]) {
        self.data = data
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
            cell.kilometerLabel.text = data[indexPath.row].kilometer
            cell.paceLabel.text = data[indexPath.row].avgPace
            cell.changeLabel.applyChange(data[indexPath.row].change)
            cell.elevationLabel.text = data[indexPath.row].elevation
        }

        return cell ?? UITableViewCell()
    }
}
