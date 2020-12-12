//
//  DetailDataSource.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class DetailDataSource: NSObject, UICollectionViewDataSource, UITableViewDataSource {
    private var cancellables = [IndexPath: AnyCancellable]()

    func numberOfSections(in _: UICollectionView) -> Int {
        4
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell?
        switch indexPath.section {
        case 0:
            let titleCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(DetailTitleCellView.self)",
                for: indexPath
            ) as? DetailTitleCellView
            cell = titleCell
        case 1:
            let totalCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(DetailTotalCellView.self)",
                for: indexPath
            ) as? DetailTotalCellView
            cell = totalCell
        case 2:
            let mapCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(DetailMapCellView.self)",
                for: indexPath
            ) as? DetailMapCellView
            cell = mapCell
        case 3:
            let splitContainerCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "\(DetailSplitsContainerCellView.self)",
                for: indexPath
            ) as? DetailSplitsContainerCellView

            cancellables[indexPath]?.cancel()
            cancellables[indexPath] = splitContainerCell?.heightChangedPublisher
                .receive(on: RunLoop.main)
                .sink {
                    guard let indexPath = collectionView.indexPath(for: $0) else { return }
                    collectionView.reloadItems(at: [indexPath])
                }

            splitContainerCell?.tableView.dataSource = self
            splitContainerCell?.tableView.reloadData()
            splitContainerCell?.layoutIfNeeded()
            cell = splitContainerCell
        default:
            cell = nil
        }

        return cell ?? UICollectionViewCell()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SimpleSplitViewCell.self)") as? SimpleSplitViewCell
        cell?.configure(style: indexPath.row == 0 ? .desc : .value)
        return cell ?? UITableViewCell()
    }
}
