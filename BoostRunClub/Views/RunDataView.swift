//
//  RunDataView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/28.
//

import UIKit

class RunDataView: UIStackView {
    enum Style {
        case main, sub
    }

    let style: Style

    private var action: (() -> Void)?

    private lazy var valueLabel: UILabel = {
        let label: UILabel
        switch style {
        case .main:
            label = NikeLabel()
        case .sub:
            label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
        label.textColor = .black
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray2.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "시간"
        return label
    }()

    init(style: Style = .sub, action: (() -> Void)? = nil) {
        self.style = style
        self.action = action

        super.init(frame: .zero)
        commonInit()
    }

    required init(coder: NSCoder) {
        style = .sub
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        distribution = .equalSpacing
        alignment = .center
        axis = .vertical

        switch style {
        case .main:
            valueLabel.font = valueLabel.font.withSize(120)
            descriptionLabel.font = descriptionLabel.font.withSize(30)
        case .sub:
            valueLabel.font = valueLabel.font.withSize(35)
            descriptionLabel.font = descriptionLabel.font.withSize(20)
        }

        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(execute)))
    }

    @objc
    private func execute() {
        action?()
    }

    func setValue(value: String) {
        valueLabel.text = value
    }

    func setType(type: String) {
        descriptionLabel.text = type
    }
}
