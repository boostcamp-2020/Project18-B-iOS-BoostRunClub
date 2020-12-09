//
//  ActivityDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivityCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var activities = [Activity]()

    func loadDatas(_ activities: [Activity]) {
        self.activities = activities
    }

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
