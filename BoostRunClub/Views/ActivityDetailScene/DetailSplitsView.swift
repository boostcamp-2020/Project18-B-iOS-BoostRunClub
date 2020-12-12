//
//  DetailSplitsView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class DetailSplitsView: UIView {
    var heightChangedPublisher = PassthroughSubject<Void, Never>()
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
}

// MARK: - Actions

extension DetailSplitsView {
    @objc
    func didTapInfoButton() {}
}

// MARK: - Configure

extension DetailSplitsView {
    private func commonInit() {
        tableView.heightPublisher
            .sink { _ in
                self.invalidateIntrinsicContentSize()
                self.heightChangedPublisher.send()
            }
            .store(in: &cancellables)

        configureLayout()
    }

    private func configureLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

        addSubview(detailInfoButton)
        detailInfoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailInfoButton.heightAnchor.constraint(equalToConstant: 60),
            detailInfoButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            detailInfoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            detailInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            detailInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
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
