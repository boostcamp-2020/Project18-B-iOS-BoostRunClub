//
//  SplitHeaderView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/09.
//

import UIKit

class SplitHeaderView: UIView {
    var inset: CGFloat = -40

    init(titles: [String], with bottomBorder: Bool = true, inset: CGFloat = -40) {
        super.init(frame: .zero)
        self.inset = inset
        configure(titles: titles, bottomBorder: bottomBorder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(titles: [String], bottomBorder: Bool) {
        backgroundColor = .systemBackground

        let labels: [UILabel] = titles.enumerated().map { idx, title in
            let label = UILabel()
            label.text = title
            label.font = label.font.withSize(17)
            label.textColor = .lightGray
            label.setTextAlignment(idx: idx, total: titles.count)
            return label
        }

        let stackView = UIStackView.make(with: labels, distribution: .fillEqually)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: inset),
            stackView.heightAnchor.constraint(equalToConstant: 60),
        ])

        if bottomBorder {
            addBottomBorder()
        }
    }

    func addBottomBorder() {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .lightGray
        addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBorder.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomBorder.widthAnchor.constraint(equalTo: widthAnchor, constant: inset),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}
