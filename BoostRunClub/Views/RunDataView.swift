//
//  RunDataView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/28.
//

import UIKit

final class RunDataView: UIStackView {
    enum Style {
        case main, sub
    }

    lazy var valueLabel = makeValueLabel()
    private lazy var descriptionLabel = maekDescriptionLabel()
    let style: Style
    var tapAction: (() -> Void)?

    init(style: Style = .sub) {
        self.style = style
        super.init(frame: .zero)
        commonInit()
    }

    required init(coder: NSCoder) {
        style = .sub
        super.init(coder: coder)
        commonInit()
    }

    func setValue(value: String) {
        valueLabel.text = value
    }

    func setType(type: String) {
        descriptionLabel.text = type
    }
}

// MARK: - Actions

extension RunDataView {
    @objc
    private func execute() {
        tapAction?()
    }

    func startBounceAnimation() {
        transform = transform.scaledBy(x: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}

// MARK: - Configure

extension RunDataView {
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(execute))

        addGestureRecognizer(tapGesture)
    }

    private func makeValueLabel() -> UILabel {
        let label: UILabel
        switch style {
        case .main:
            label = NikeLabel()
        case .sub:
            label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
        label.textColor = UIColor(named: "accent2")
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }

    private func maekDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.systemGray2.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "시간"
        return label
    }
}
