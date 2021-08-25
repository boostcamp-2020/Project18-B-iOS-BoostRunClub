//
//  DetailSplitsView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class DetailSplitsView: UIView {
    private(set) var didHeightChangeSignal = PassthroughSubject<Void, Never>()
    private(set) var didTapInfoButtonSignal = PassthroughSubject<Void, Never>()

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
    func didTapInfoButton() {
        didTapInfoButtonSignal.send()
    }
}

// MARK: - Configure

extension DetailSplitsView {
    private func commonInit() {
        tableView.didIntrinsicSizeChangedSignal
            .sink { [weak self] _ in
                self?.didHeightChangeSignal.send()
            }
            .store(in: &cancellables)

        configureLayout()
    }

    private func configureLayout() {
        let vStack = UIStackView.make(
            with: [titleLabel, tableView, detailInfoButton],
            axis: .vertical, alignment: .fill, distribution: .equalSpacing, spacing: 10
        )
        addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        detailInfoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailInfoButton.heightAnchor.constraint(equalToConstant: 60),
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
