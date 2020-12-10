//
//  ActivityFooterView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import UIKit

class ActivityFooterView: UIView {
    private var showAllActivityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모든 활동", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapShowAllActivity), for: .touchUpInside)
        return button
    }()

    var didTapAllActivityButton: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        commonInit()
    }
}

// MARK: - Actions

extension ActivityFooterView {
    @objc
    func didTapShowAllActivity() {
        didTapAllActivityButton?()
    }
}

// MARK: - Configure

extension ActivityFooterView {
    private func commonInit() {
        backgroundColor = .clear
        configureLayout()
    }

    private func configureLayout() {
        addSubview(showAllActivityButton)
        showAllActivityButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showAllActivityButton.widthAnchor.constraint(equalToConstant: bounds.width - 40),
            showAllActivityButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showAllActivityButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showAllActivityButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
