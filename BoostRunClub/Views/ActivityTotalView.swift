//
//  ActivityTotalView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class ActivityTotalView: UIView {
    lazy var segmentedControl = makeSegmentedControl()
    lazy var dateButton = makeDateLabeButton()
    lazy var distanceValueLabel = NikeLabel(with: 50)
    lazy var distancelabel = makeNormalLabel()
    lazy var numRunningValueLabel = makeValueLabel()
    lazy var numRunningLabel = makeNormalLabel()
    lazy var avgPaceValueLabel = makeValueLabel()
    lazy var avgPaceLabel = makeNormalLabel()
    lazy var runningTimeValueLabel = makeValueLabel()
    lazy var runningTimeLabel = makeNormalLabel()

    private var dateButtonActiveIcon: UIImage? = UIImage.SFSymbol(name: "chevron.down", color: .label)
    private var dateButtonDeActiveIcon: UIImage? = UIImage.SFSymbol(name: "chevron.down", color: .clear)

    var didChangeSelectedItem: ((Int) -> Void)?
    var didTapShowDateFilter: (() -> Void)?
    var actionSendable: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    func configure(config: ActivityTotalConfig) {
        dateButton.setTitle(config.period, for: .normal)
        distanceValueLabel.text = config.totalDistanceText
        numRunningValueLabel.text = config.numRunningText
        avgPaceValueLabel.text = config.avgPaceText
        runningTimeValueLabel.text = config.totalRunningTimeText
        switch config.filterType {
        case .year, .month, .week:
            dateButton.setImage(dateButtonActiveIcon, for: .normal)
            actionSendable = true
        case .all:
            dateButton.setImage(dateButtonDeActiveIcon, for: .normal)
            actionSendable = false
        }
    }

    func selfResizing() {
        setNeedsLayout()
        layoutIfNeeded()

        let height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var newFrame = frame
        newFrame.size.height = height
        frame = newFrame
    }
}

// MARK: - Actions

extension ActivityTotalView {
    @objc
    func didTapDateButton() {
        if actionSendable {
            didTapShowDateFilter?()
        }
    }
}

// MARK: - Configure

extension ActivityTotalView {
    private func commonInit() {
        backgroundColor = .systemBackground

        segmentedControl.didChangeSelectedItem = { [weak self] idx in
            self?.didChangeSelectedItem?(idx)
        }

        configureLayout()
    }

    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])

        let distanceStackView = UIStackView.make(
            with: [distanceValueLabel, distancelabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fillProportionally
        )

        let numRunningStackView = UIStackView.make(
            with: [numRunningValueLabel, numRunningLabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fillProportionally
        )

        let avgPaceStackView = UIStackView.make(
            with: [avgPaceValueLabel, avgPaceLabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fillProportionally
        )

        let runningTimeStackView = UIStackView.make(
            with: [runningTimeValueLabel, runningTimeLabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fillProportionally
        )

        let dataHStackView = UIStackView.make(
            with: [numRunningStackView, avgPaceStackView, runningTimeStackView],
            axis: .horizontal,
            alignment: .leading,
            distribution: .fill,
            spacing: 20
        )

        let vStackView = UIStackView.make(
            with: [segmentedControl, dateButton, distanceStackView, dataHStackView],
            axis: .vertical,
            alignment: .leading,
            distribution: .fill,
            spacing: 15
        )
        addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: vStackView.widthAnchor, constant: -10),
        ])
    }

    private func makeSegmentedControl() -> RoundSegmentControl {
        let items = ["주", "월", "년", "전체"]
        let control = RoundSegmentControl(
            items: items,
            background: .systemBackground,
            foreground: .label,
            selectedColor: .systemBackground,
            normalColor: .systemGray,
            borderColor: .systemGray
        )
        return control
    }

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

    private func makeDateLabeButton() -> UIButton {
        let button = UIButton()
        button.setTitle("날짜 선택", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setImage(dateButtonActiveIcon, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets.right = -10
        button.addTarget(self, action: #selector(didTapDateButton), for: .touchUpInside)
        return button
    }
}
