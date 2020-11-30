//
//  GoalTypeActionSheetView.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/24.
//

import UIKit

class GoalTypeCell: UITableViewCell {
    let goalTypeLabel = UILabel()
    let checkmarkLabel = UILabel()
    let inset: CGFloat = 20
    static let cellHeight: CGFloat = 100

    var goalType = GoalType.none

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(_ goalType: GoalType) {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        self.goalType = goalType
        goalTypeLabel.text = goalType.description
        commonInit()
    }
}

// MARK: - Configure

extension GoalTypeCell {
    private func commonInit() {
        goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(goalTypeLabel)
        contentView.addSubview(checkmarkLabel)

        NSLayoutConstraint.activate([
            goalTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            goalTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            checkmarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            checkmarkLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
