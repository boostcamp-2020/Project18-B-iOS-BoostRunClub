//
//  ActivityStatisticCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class ActivityStatisticCellView: UITableViewCell {
    private lazy var titleLabel = makeNormalLabel()
    private lazy var valueLabel = makeValueLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init(title: String, value: String) {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        commonInit()
        configure(title: title, value: value)
    }

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        commonInit()
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

// MARK: - Configure

extension ActivityStatisticCellView {
    private func commonInit() {
        selectionStyle = .none
        configureLayout()
    }

    private func configureLayout() {
        let stackView = UIStackView.make(
            with: [titleLabel, valueLabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fill,
            spacing: 10
        )
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    private func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
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
