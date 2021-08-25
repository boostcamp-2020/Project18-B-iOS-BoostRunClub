//
//  DetailTitleView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class DetailTitleView: UIView {
    private var dateLabel = UILabel.makeNormal()
    private var titleLabel = UILabel.makeBold()
    private var dividerView = UIView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(dateText: String, title: String) {
        dateLabel.text = dateText
        titleLabel.text = title
    }
}

// MARK: - Configure

extension DetailTitleView {
    private func commonInit() {
        dividerView.backgroundColor = .systemGray
        configureLayout()
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
        ])

        let titleVStack = UIStackView.make(
            with: [dateLabel, titleLabel, dividerView],
            axis: .vertical, alignment: .leading, distribution: .fill, spacing: 10
        )

        addSubview(titleVStack)
        titleVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleVStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
