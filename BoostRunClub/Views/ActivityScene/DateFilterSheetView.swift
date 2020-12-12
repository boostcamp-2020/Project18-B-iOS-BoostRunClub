//
//  DateFilterSheetView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import UIKit

class DateFilterSheetView: UIScrollView {
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    private(set) var pickerView = UIPickerView()
    private lazy var selectButton = makeSelectButton()

    var didTapSelect: (() -> Void)?

    init(contentSize: CGSize) {
        super.init(frame: .zero)
        self.contentSize = contentSize
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Actions

extension DateFilterSheetView {
    @objc
    func didTapSelectButton() {
        didTapSelect?()
    }
}

// MARK: - Configure

extension DateFilterSheetView {
    private func commonInit() {
        configureLayout()
    }

    private func configureLayout() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: contentSize.width),
            contentView.heightAnchor.constraint(equalToConstant: contentSize.height),
        ])

        let vStack = UIStackView.make(
            with: [pickerView, selectButton],
            axis: .vertical,
            alignment: .center,
            distribution: .fillProportionally,
            spacing: 10
        )
        contentView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])

        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            selectButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func makeSelectButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .label
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        return button
    }
}
