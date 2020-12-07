//
//  ActivityCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class ActivityCellView: UITableViewCell {
    private lazy var thumbnailImage = UIImageView(image: UIImage.SFSymbol(name: "person.circle.fill"))
    private lazy var dateLabel = makeValueLabel()
    private lazy var titleLabel = makeNormalLabel()
    private lazy var distanceValueLabel = makeValueLabel()
    private lazy var distanceLabel = makeNormalLabel()
    private lazy var avgPaceValueLabel = makeValueLabel()
    private lazy var avgPaceLabel = makeNormalLabel()
    private lazy var runningTimeValueLabel = makeValueLabel()
    private lazy var runningTimeLabel = makeNormalLabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        commonInit()
    }

    func configure(with _: Activity) {
        dateLabel.text = "오늘"
        titleLabel.text = "월요일 야간 러닝"
        distanceValueLabel.text = "7.46"
        avgPaceValueLabel.text = "13'18\""
        runningTimeValueLabel.text = "1:18:37"
    }
}

// MARK: - Configure

extension ActivityCellView {
    private func commonInit() {
        selectionStyle = .none
        configureLayout()
        distanceLabel.text = "Km"
        avgPaceLabel.text = "평균 페이스"
        runningTimeLabel.text = "시간"
    }

    private func configureLayout() {
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImage.widthAnchor.constraint(equalToConstant: 50),
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor),
        ])

        let titleStackView = UIStackView.make(
            with: [dateLabel, titleLabel],
            axis: .vertical,
            alignment: .leading,
            distribution: .fill
        )

        let titleHStackView = UIStackView.make(
            with: [thumbnailImage, titleStackView],
            axis: .horizontal,
            alignment: .center,
            distribution: .fill,
            spacing: 10
        )

        let distanceStackView = UIStackView.make(
            with: [distanceValueLabel, distanceLabel],
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
            with: [distanceStackView, avgPaceStackView, runningTimeStackView],
            axis: .horizontal,
            alignment: .leading,
            distribution: .fill,
            spacing: 50
        )

        let stackView = UIStackView.make(
            with: [titleHStackView, dataHStackView],
            axis: .vertical,
            alignment: .leading,
            distribution: .equalSpacing,
            spacing: 10
        )

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    private func makeValueLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
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
