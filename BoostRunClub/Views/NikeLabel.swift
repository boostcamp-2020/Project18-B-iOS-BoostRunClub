//
//  nikeLabel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/28.
//

import UIKit

class NikeLabel: UILabel {
    init(with size: CGFloat = 17) {
        super.init(frame: .zero)
        commonInit(with: size)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(with size: CGFloat = 17) {
        font = UIFont(name: "FuturaLT-CondExtraBoldObl", size: size)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        if
            let length = text?.count,
            length > 0
        {
            let adder = size.width / CGFloat(length) / 5
            size.width += adder
        }

        return size
    }
}
