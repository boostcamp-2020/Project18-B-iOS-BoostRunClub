//
//  DetailTitleCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class DetailTitleCellView: UICollectionViewCell {
    private var dateLabel = UILabel.makeNormal()
    private var titleLabel = UILabel.makeBold()
    private var dividerView = UIView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(with _: ActivityTotalConfig) {}

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

// MARK: - Configure

extension DetailTitleCellView {
    private func commonInit() {
        dividerView.backgroundColor = .systemGray
        configureLayout()
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
        ])

        let titleVStack = UIStackView.make(
            with: [dateLabel, titleLabel, dividerView],
            axis: .vertical, alignment: .leading, distribution: .fill, spacing: 10
        )

        contentView.addSubview(titleVStack)
        titleVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
