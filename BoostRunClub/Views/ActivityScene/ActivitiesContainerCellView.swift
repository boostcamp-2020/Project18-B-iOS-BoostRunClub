//
//  ActivityCollectionContainerView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivitiesContainerCellView: UITableViewCell {
    lazy var collectionView = ActivityCollectionView()
    var didChangeCellSize: ((CGSize) -> Void)?

    init() {
        super.init(style: .default, reuseIdentifier: "\(Self.self)")
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        contentView.backgroundColor = .red
        collectionView.didContentSizeChanged = { [weak self] size in
            if size != self?.frame.size {
                self?.frame.size = size
                self?.didChangeCellSize?(size)
            }
        }
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
