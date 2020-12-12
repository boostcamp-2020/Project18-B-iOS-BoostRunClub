//
//  SimpleSplitView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class SimpleSplitViewCell: UITableViewCell {
    enum Style {
        case desc, value
    }

    enum Constant {
        static let cellHeight: CGFloat = 50
        static let paceMinWidth: CGFloat = 120
    }

    private var distanceLabel = UILabel.makeBold(text: "Km")
    private var paceForegroundView = UIView()
    private var paceBackgroundView = UIView()
    private var paceLabel = UILabel.makeBold(text: "평균 페이스")
    private var elevationLabel = UILabel.makeBold(text: "고도")

    private lazy var paceContainerWidthConstraint = paceForegroundView.widthAnchor.constraint(equalToConstant: Constant.paceMinWidth)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: style, reuseIdentifier: "\(SimpleSplitViewCell.self)")
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(
        style: Style = .value,
        distance: String = "",
        pace: String = "",
        elevation: String = "",
        paceRatio: CGFloat = 0
    ) {
        switch style {
        case .desc:
            distanceLabel.textColor = .systemGray
            paceLabel.textColor = .systemGray
            elevationLabel.textColor = .systemGray
            paceForegroundView.backgroundColor = .clear
        case .value:
            distanceLabel.textColor = .label
            paceLabel.textColor = .label
            elevationLabel.textColor = .label
            distanceLabel.text = distance
            paceLabel.text = pace
            elevationLabel.text = elevation
            paceForegroundView.backgroundColor = .systemGray6
            setAvgProgress(to: paceRatio)
        }
    }

    private func setAvgProgress(to progress: CGFloat) {
        let progress = progress == .nan ? 0 : progress
        let fullWidth = paceBackgroundView.bounds.width
        let progressWidth = Constant.paceMinWidth + (fullWidth - Constant.paceMinWidth) * progress
        paceContainerWidthConstraint.constant = progressWidth
    }
}

// MARK: - Configure

extension SimpleSplitViewCell {
    private func commonInit() {
        backgroundColor = .clear
        configureLayout()
    }

    private func configureLayout() {
        let hStack = UIStackView.make(
            with: [distanceLabel, paceBackgroundView, elevationLabel],
            axis: .horizontal, alignment: .center, distribution: .fill, spacing: 20
        )

        contentView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        paceBackgroundView.addSubview(paceForegroundView)
        paceForegroundView.addSubview(paceLabel)
        paceBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paceBackgroundView.heightAnchor.constraint(equalToConstant: Constant.cellHeight),
        ])

        paceForegroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paceForegroundView.topAnchor.constraint(equalTo: paceBackgroundView.topAnchor, constant: 5),
            paceForegroundView.bottomAnchor.constraint(equalTo: paceBackgroundView.bottomAnchor, constant: -5),
            paceForegroundView.leadingAnchor.constraint(equalTo: paceBackgroundView.leadingAnchor),
            paceContainerWidthConstraint,
        ])

        paceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paceLabel.leadingAnchor.constraint(equalTo: paceForegroundView.leadingAnchor, constant: 10),
            paceLabel.centerYAnchor.constraint(equalTo: paceForegroundView.centerYAnchor),
        ])
    }
}
