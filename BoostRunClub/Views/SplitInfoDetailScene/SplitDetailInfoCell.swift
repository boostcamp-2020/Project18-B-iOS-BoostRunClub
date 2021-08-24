//
//  SplitDetailInfoCell.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

class SplitDetailInfoCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    private let fontSize: CGFloat = 17

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func commonInit() {
        let stackView = UIStackView.make(with: [titleLabel, valueLabel], distribution: .fillEqually)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
