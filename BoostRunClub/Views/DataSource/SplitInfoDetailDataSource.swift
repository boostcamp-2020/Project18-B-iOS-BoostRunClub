//
//  SplitInfoDetailDataSource.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

struct SplitInfo {
    let title: String
    let value: String
}

class SplitInfoDetailDataSource: NSObject, UITableViewDataSource {
    var data = [SplitInfo]()

    func update(_ data: [SplitInfo]) {
        self.data = data
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SplitDetailInfoCell.identifier,
            for: indexPath
        )

        if let cell = cell as? SplitDetailInfoCell {
            cell.titleLabel.text = data[indexPath.row].title
            cell.valueLabel.text = data[indexPath.row].value
        }

        return cell
    }
}
