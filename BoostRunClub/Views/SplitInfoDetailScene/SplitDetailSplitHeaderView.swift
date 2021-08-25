//
//  SplitDetailSplitHeaderView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

class SplitDetailSplitHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구간"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .label
        return label
    }()

    private let secondView = SplitHeaderView(titles: ["KM", "평균 페이스", "+/-", "고도"], with: false, inset: 0)
    private let inset: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        ])

        addSubview(secondView)
        secondView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            secondView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            secondView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            secondView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
