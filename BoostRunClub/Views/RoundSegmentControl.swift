//
//  RoundSegmentControl.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class RoundSegmentControl: UIView {
    var background: UIColor
    var foreground: UIColor
    var selectedLabelColor: UIColor
    var normalLabelColor: UIColor
    var borderColor: UIColor

    private var items: [UIButton] = []
    lazy var focusedView: UILabel = {
        let label = UILabel()
        label.backgroundColor = self.foreground
        label.textColor = self.selectedLabelColor
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()

    var selectedIdx: Int = 0 {
        didSet {
            if oldValue != selectedIdx {
                didItemChanged(from: oldValue, to: selectedIdx)
            }
        }
    }

    var didChangeSelectedItem: ((Int) -> Void)?

    init(
        items: [String],
        background: UIColor,
        foreground: UIColor,
        selectedColor: UIColor,
        normalColor: UIColor,
        borderColor: UIColor
    ) {
        self.background = background
        self.foreground = foreground
        selectedLabelColor = selectedColor
        normalLabelColor = normalColor
        self.borderColor = borderColor
        super.init(frame: .zero)
        commonInit(items: items)
    }

    required init?(coder: NSCoder) {
        background = .clear
        foreground = .black
        selectedLabelColor = .white
        normalLabelColor = .black
        borderColor = .clear
        super.init(coder: coder)
        commonInit(items: [])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
        focusedView.layer.cornerRadius = bounds.height / 2

        if !items.isEmpty {
            focusedView.frame = items[selectedIdx].frame
        }
    }
}

// MARK: - Actions

extension RoundSegmentControl {
    @objc
    func didTapItem(_ button: UIButton) {
        guard
            let idx = items.firstIndex(of: button),
            idx != selectedIdx
        else { return }
        selectedIdx = idx
        didChangeSelectedItem?(idx)
    }

    private func didItemChanged(from oldIdx: Int, to newIdx: Int) {
        let prevItem = items[oldIdx]
        let newItem = items[newIdx]

        prevItem.setTitleColor(normalLabelColor, for: .normal)
        newItem.setTitleColor(background, for: .normal)

        focusedView.text = ""
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.8,
            animations: {
                self.focusedView.frame = newItem.frame
            },
            completion: { _ in
                self.focusedView.text = newItem.currentTitle
            }
        )
    }
}

// MARK: - Configure

extension RoundSegmentControl {
    private func commonInit(items: [String]) {
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        items.forEach { self.items.append(makeSegmentItem(title: $0)) }
        configureLayout()

        if !items.isEmpty {
            focusedView.text = items[0]
        }
    }

    private func configureLayout() {
        let segmentStackView = UIStackView.make(
            with: items, axis: .horizontal,
            alignment: .center,
            distribution: .fillEqually,
            spacing: 0
        )
        addSubview(segmentStackView)
        segmentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentStackView.topAnchor.constraint(equalTo: topAnchor),
            segmentStackView.leftAnchor.constraint(equalTo: leftAnchor),
            segmentStackView.rightAnchor.constraint(equalTo: rightAnchor),
            segmentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        addSubview(focusedView)
    }

    private func makeSegmentItem(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = background
        button.setTitleColor(normalLabelColor, for: .normal)
        button.addTarget(self, action: #selector(didTapItem(_:)), for: .touchUpInside)
        return button
    }
}
