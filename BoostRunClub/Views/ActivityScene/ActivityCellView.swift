//
//  ActivityCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class ActivityCellView: UICollectionViewCell {
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

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    func configure(with activity: Activity) {
        dateLabel.text = activity.dateText(with: Date())
        titleLabel.text = activity.titleText
        distanceValueLabel.text = activity.distanceText
        avgPaceValueLabel.text = activity.avgPaceText
        runningTimeValueLabel.text = activity.runningTimeText
        guard let data = activity.thumbnail else { return }
        thumbnailImage.image = UIImage(data: data)
    }
}

// MARK: - Configure

extension ActivityCellView {
    private func commonInit() {
        configureLayout()
        distanceLabel.text = "Km"
        avgPaceLabel.text = "평균 페이스"
        runningTimeLabel.text = "시간"
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    // swiftlint:disable:next function_body_length
    private func configureLayout() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
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
            distribution: .equalSpacing,
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
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
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
