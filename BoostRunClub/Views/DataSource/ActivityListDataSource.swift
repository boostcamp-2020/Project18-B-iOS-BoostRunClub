//
//  ActivityListDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivityListDataSource: NSObject, UICollectionViewDataSource {
    var listItem = [ActivityListItem]()

    func loadData(_ listItem: [ActivityListItem]) {
        self.listItem = listItem
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        listItem.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listItem[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(ActivityCellView.self)",
            for: indexPath
        )

        if let cell = cell as? ActivityCellView {
            cell.configure(with: listItem[indexPath.section].items[indexPath.row])
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "\(ActivityListHeaderView.self)",
            for: indexPath
        )

        if let header = header as? ActivityListHeaderView {
            header.configure(with: listItem[indexPath.section].total)
        }

        return header
    }
}
