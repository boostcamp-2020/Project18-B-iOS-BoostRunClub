//
//  CountDownView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/02.
//

import UIKit

class CountDownView: UIView {
    let numberLabel: NikeLabel = {
        let label = NikeLabel(with: 180)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .black

        addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func startCountingAnimation(count: Int, completion: @escaping () -> Void) {
        if count <= 0 {
            completion()
            return
        }
        numberLabel.text = "\(count)"
        numberLabel.transform = numberLabel.transform.scaledBy(x: 0.5, y: 0.5)
        UIView.animate(withDuration: 1) {
            self.numberLabel.transform = .identity
        } completion: { _ in
            self.startCountingAnimation(count: count - 1, completion: completion)
        }
    }
}
