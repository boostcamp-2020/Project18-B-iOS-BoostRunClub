//
//  ActivityListHeaderView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivityListHeaderView: UICollectionReusableView {
    lazy var categoryLabel = makeValueLabel()
    lazy var numRunningLabel = makeNormalLabel()
    lazy var distancelabel = makeNormalLabel()
    lazy var paceLabel = makeNormalLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(with config: ActivityTotalConfig) {
        categoryLabel.text = config.totalRange.start.toYMString
        numRunningLabel.text = "러닝 \(config.numRunningText)회"
        distancelabel.text = "\(config.totalDistanceText)km"
        paceLabel.text = "\(config.avgPaceText)/km"
    }

    private func commonInit() {
        backgroundColor = .systemGroupedBackground
        configureLayout()
    }

    private func configureLayout() {
        let valueHStack = UIStackView.make(
            with: [numRunningLabel, distancelabel, paceLabel],
            axis: .horizontal,
            alignment: .leading,
            distribution: .equalSpacing,
            spacing: 10
        )

        let totalVStack = UIStackView.make(
            with: [categoryLabel, valueHStack],
            axis: .vertical,
            alignment: .leading,
            distribution: .equalSpacing,
            spacing: 5
        )

        addSubview(totalVStack)
        totalVStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            totalVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalVStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            totalVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            totalVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}

// MARK: - Configure

extension ActivityListHeaderView {
    private func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.text = "Value"
        return label
    }

    private func makeNormalLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = "타이틀"
        return label
    }
}
