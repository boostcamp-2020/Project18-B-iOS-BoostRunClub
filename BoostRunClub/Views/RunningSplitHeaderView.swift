//
//  RunningSplitHeaderView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/09.
//

import UIKit

class RunningSplitHeaderView: UIView {
    init(titles: [String]) {
        super.init(frame: .zero)
        configure(titles: titles)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(titles: [String]) {
        backgroundColor = .systemBackground

        let labels: [UILabel] = titles.enumerated().map { idx, title in
            let label = UILabel()
            label.text = title
            label.font = label.font.withSize(17)
            label.textColor = .lightGray
            label.setTextAlignment(idx: idx, total: titles.count)
            return label
        }

        let stackView = UIStackView.make(with: labels, distribution: .fillEqually, spacing: 20)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .lightGray
        addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}
