//
//  GoalValueView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/26.
//

import UIKit

final class GoalValueView: UIView {
    private lazy var goalValueLabel: UILabel = makeGoalValueLabel()

    var tapAction: (() -> Void)?
    let underline: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "킬로미터"
        return label
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func setLabelText(goalValue: String, goalUnit: String) {
        goalValueLabel.text = goalValue
        descriptionLabel.text = goalUnit
    }
}

// MARK: - Actions

extension GoalValueView {
    @objc
    private func execute() {
        tapAction?()
    }
}

// MARK: - Configure

extension GoalValueView {
    func commonInit() {
        isUserInteractionEnabled = true
        configureLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(execute))
        addGestureRecognizer(tapGesture)
    }

    func configureLayout() {
        addSubview(goalValueLabel)
        goalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalValueLabel.topAnchor.constraint(equalTo: topAnchor),
            goalValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            goalValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
        ])
        goalValueLabel.setContentCompressionResistancePriority(.init(rawValue: 999), for: .horizontal)

        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: goalValueLabel.lastBaselineAnchor, constant: 9),
            underline.trailingAnchor.constraint(equalTo: goalValueLabel.trailingAnchor),
            underline.leadingAnchor.constraint(equalTo: goalValueLabel.leadingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1),
        ])

        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: underline.bottomAnchor, constant: 7),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func makeGoalValueLabel() -> UILabel {
        let label = NikeLabel(with: 50)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }

    func makeSetGoalButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "FuturaLT-CondExtraBoldObl", size: 50)
        button.contentHorizontalAlignment = .fill

        return button
    }
}
