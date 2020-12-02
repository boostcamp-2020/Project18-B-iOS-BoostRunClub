//
//  GoalTypeActionSheetView.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/24.
//

import UIKit

class GoalTypeCell: UITableViewCell {
    enum Style {
        case checked, black, gray
    }

    private let goalTypeLabel = UILabel()
    private lazy var checkMarkImage = makeCheckMark()

    let goalType: GoalType

    required init?(coder: NSCoder) {
        goalType = .none
        super.init(coder: coder)
        commonInit(goalType)
    }

    init(_ goalType: GoalType) {
        self.goalType = goalType
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        commonInit(goalType)
    }

    private func commonInit(_ goalType: GoalType) {
        goalTypeLabel.text = goalType.description
        configureLayout()
    }

    func setStyle(with style: Style) {
        switch style {
        case .checked:
            checkMarkImage.isHidden = false
            goalTypeLabel.textColor = .label
        case .black:
            checkMarkImage.isHidden = true
            goalTypeLabel.textColor = .label
        case .gray:
            checkMarkImage.isHidden = true
            goalTypeLabel.textColor = .systemGray
        }
    }
}

// MARK: - Configure

extension GoalTypeCell {
    private func makeCheckMark() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark")?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        return view
    }

    private func configureLayout() {
        contentView.addSubview(goalTypeLabel)
        goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.inset),
            goalTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        contentView.addSubview(checkMarkImage)
        checkMarkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkMarkImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.inset
            ),
            checkMarkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMarkImage.heightAnchor.constraint(equalTo: goalTypeLabel.heightAnchor, multiplier: 1.2),
            checkMarkImage.widthAnchor.constraint(equalTo: checkMarkImage.heightAnchor),
        ])
    }
}

// MARK: - LayoutConstant

extension GoalTypeCell {
    enum LayoutConstant {
        static let inset: CGFloat = 20
        static let cellHeight: CGFloat = 100
    }
}
