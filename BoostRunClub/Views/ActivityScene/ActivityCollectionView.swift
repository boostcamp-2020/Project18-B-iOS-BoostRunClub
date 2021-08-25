//
//  ActivityCollectionView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Combine
import UIKit

class ActivityCollectionView: UICollectionView {
    var didHeightChangeSignal = PassthroughSubject<CGFloat, Never>()

    init(frame _: CGRect = .zero) {
        let layout = ActivityCollectionView.makeLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
            didHeightChangeSignal.send(intrinsicContentSize.height)
        }
    }

    override var intrinsicContentSize: CGSize {
        collectionViewLayout.collectionViewContentSize
    }

    private func commonInit() {
        register(ActivityCellView.self, forCellWithReuseIdentifier: "\(ActivityCellView.self)")
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = .clear
        isScrollEnabled = false
        layer.masksToBounds = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    static func makeLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
