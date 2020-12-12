//
//  DetailSplitsContainerCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class DetailSplitsContainerCellView: UICollectionViewCell {
    var heightChangedPublisher = PassthroughSubject<UICollectionViewCell, Never>()
    var tabInfoButtonSignal = PassthroughSubject<IndexPath, Never>()

    private var titleLabel = UILabel.makeBold(text: "구간", size: 30)
    private(set) var tableView = DetailSplitsTableView()
    private lazy var detailInfoButton = makeDetailInfoButton()

    private lazy var tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
}

// MARK: - Actions

extension DetailSplitsContainerCellView {
    @objc
    func didTapInfoButton() {}
}

// MARK: - Configure

extension DetailSplitsContainerCellView {
    private func commonInit() {
        tableView.heightPublisher
            .sink {
                self.tableHeightConstraint.constant = $0
                self.heightChangedPublisher.send(self)
            }
            .store(in: &cancellables)

        configureLayout()
    }

    private func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])

        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        contentView.addSubview(detailInfoButton)
        detailInfoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailInfoButton.heightAnchor.constraint(equalToConstant: 60),
            detailInfoButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            detailInfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailInfoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailInfoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    private func makeDetailInfoButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("상세 정보", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        return button
    }
}
