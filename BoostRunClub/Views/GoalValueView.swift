//
//  GoalValueView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/26.
//

import UIKit

class GoalValueView: UIView {
    let setGoalDetailButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "FuturaLT-CondExtraBoldObl", size: 50)
        button.contentHorizontalAlignment = .fill

        return button
    }()

    var goalDetailButtonWidthConstraint: NSLayoutConstraint?

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

    func commonInit() {
        configureLayout()
    }

    func configureLayout() {
        addSubview(setGoalDetailButton)
        setGoalDetailButton.translatesAutoresizingMaskIntoConstraints = false
        goalDetailButtonWidthConstraint = setGoalDetailButton.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            setGoalDetailButton.topAnchor.constraint(equalTo: topAnchor),
            setGoalDetailButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            setGoalDetailButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            goalDetailButtonWidthConstraint!,
        ])

        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: setGoalDetailButton.lastBaselineAnchor, constant: 9),
            underline.trailingAnchor.constraint(equalTo: setGoalDetailButton.trailingAnchor),
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

    func setLabelText(goalValue: String, goalUnit: String) {
        setGoalDetailButton.setTitle(goalValue, for: .normal)

        let widthSize = (setGoalDetailButton.titleLabel?.intrinsicContentSize.width ?? 0) + 5
        goalDetailButtonWidthConstraint?.constant = widthSize
        descriptionLabel.text = goalUnit
    }

    func setGoalUnit(goalUnit _: String) {}
}
