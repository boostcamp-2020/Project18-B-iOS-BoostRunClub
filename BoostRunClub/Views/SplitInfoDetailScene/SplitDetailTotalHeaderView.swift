//
//  SplitDetailTotalHeaderView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

class SplitDetailTotalHeaderView: UICollectionReusableView {
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let inset: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        backgroundColor = .systemBackground
        dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
        timeLabel.font = UIFont.systemFont(ofSize: 17)

        let stackView = UIStackView.make(with: [dateLabel, timeLabel],
                                         axis: .vertical,
                                         spacing: 10)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        ])
    }
}
