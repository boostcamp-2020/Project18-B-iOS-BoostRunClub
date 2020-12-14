//
//  SplitDetailTotalHeaderView.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

class SplitDetailDateInfoView: UIView {
    let dateLabel = UILabel()
    let timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        dateLabel.text = "Sunday, December 6"
        timeLabel.text = "11:36 pm - 1:00am"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var stackView: UIStackView?

    private func configure() {
        backgroundColor = .systemBackground
        dateLabel.font = UIFont.boldSystemFont(ofSize: 24)
        timeLabel.font = UIFont.systemFont(ofSize: 17)

        let stackView = UIStackView.make(with: [dateLabel, timeLabel],
                                         axis: .vertical,
                                         spacing: 10)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
        ])
        self.stackView = stackView
    }
}

extension UILabel {
    func setTextAlignment(idx: Int, total: Int) {
        textAlignment = [.left, .center, .right][idx == 0 ? 0 : 1 + (idx + 1) / total]
    }
}
