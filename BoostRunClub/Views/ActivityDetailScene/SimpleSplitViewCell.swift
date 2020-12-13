//
//  SimpleSplitView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class SimpleSplitViewCell: UITableViewCell {
    enum Style {
        case description, value
    }

    enum Constant {
        static let cellHeight: CGFloat = 50
        static let paceMinWidth: CGFloat = 120
    }

    private var distanceLabel = UILabel.makeBold(text: "Km")
    private var distanceBackgroundView = UIView()
    private var paceForegroundView = UIView()
    private var paceBackgroundView = UIView()
    private var paceLabel = UILabel.makeBold(text: "평균 페이스")
    private var elevationLabel = UILabel.makeBold(text: "고도")
    private var elevationBackgroundView = UIView()

    private lazy var paceContainerWidthConstraint
        = paceForegroundView.widthAnchor.constraint(equalToConstant: Constant.paceMinWidth)

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
        case .description:
            distanceLabel.textColor = .systemGray
            paceLabel.textColor = .systemGray
            elevationLabel.textColor = .systemGray
            distanceLabel.text = "Km"
            paceLabel.text = "평균 페이스"
            elevationLabel.text = "고도"
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
        layoutIfNeeded()
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

    // swiftlint:disable:next function_body_length
    private func configureLayout() {
        contentView.addSubview(distanceBackgroundView)
        contentView.addSubview(paceBackgroundView)
        contentView.addSubview(elevationBackgroundView)

        distanceBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        elevationBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        paceBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            distanceBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            distanceBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            distanceBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            distanceBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),

            paceBackgroundView.leadingAnchor.constraint(equalTo: distanceBackgroundView.trailingAnchor),
            paceBackgroundView.trailingAnchor.constraint(equalTo: elevationBackgroundView.leadingAnchor),
            paceBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            paceBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

            elevationBackgroundView.leadingAnchor.constraint(equalTo: paceBackgroundView.trailingAnchor),
            elevationBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            elevationBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            elevationBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            elevationBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
        ])

        distanceBackgroundView.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.leadingAnchor.constraint(equalTo: distanceBackgroundView.leadingAnchor),
            distanceLabel.centerYAnchor.constraint(equalTo: distanceBackgroundView.centerYAnchor),
        ])

        elevationBackgroundView.addSubview(elevationLabel)
        elevationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            elevationLabel.trailingAnchor.constraint(equalTo: elevationBackgroundView.trailingAnchor),
            elevationLabel.centerYAnchor.constraint(equalTo: elevationBackgroundView.centerYAnchor),
        ])

        paceBackgroundView.addSubview(paceForegroundView)
        paceForegroundView.addSubview(paceLabel)
        paceForegroundView.translatesAutoresizingMaskIntoConstraints = false
        paceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            paceForegroundView.leadingAnchor.constraint(equalTo: paceBackgroundView.leadingAnchor),
            paceForegroundView.topAnchor.constraint(equalTo: paceBackgroundView.topAnchor),
            paceForegroundView.bottomAnchor.constraint(equalTo: paceBackgroundView.bottomAnchor),
            paceContainerWidthConstraint,

            paceLabel.leadingAnchor.constraint(equalTo: paceForegroundView.leadingAnchor, constant: 20),
            paceLabel.centerYAnchor.constraint(equalTo: paceForegroundView.centerYAnchor),
        ])

        let centerHuggingP = paceBackgroundView.contentHuggingPriority(for: .horizontal)
        elevationBackgroundView.setContentHuggingPriority(.init(centerHuggingP.rawValue - 1), for: .horizontal)
    }
}
