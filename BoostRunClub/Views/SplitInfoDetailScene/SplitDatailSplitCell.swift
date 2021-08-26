//
//  SplitDatailSplitCell.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

class SplitDatailSplitCell: UITableViewCell {
    let kilometerLabel = UILabel()
    let paceLabel = UILabel()
    let changeLabel = UILabel()
    let elevationLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        kilometerLabel.text = "asdf"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func commonInit() {
        let labels = [kilometerLabel, paceLabel, changeLabel, elevationLabel]
        labels.enumerated().forEach { idx, label in
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .label
            label.setTextAlignment(idx: idx, total: labels.count)
        }
        kilometerLabel.textColor = .systemGray

        let stackView = UIStackView.make(with: labels, distribution: .fillEqually)
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
