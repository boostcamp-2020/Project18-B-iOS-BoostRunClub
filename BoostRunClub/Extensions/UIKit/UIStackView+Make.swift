//
//  UIStackView+Make.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

extension UIStackView {
    static func make(
        with subviews: [UIView],
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: CGFloat = 0
    ) -> UIStackView {
        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = axis
        view.alignment = alignment
        view.distribution = distribution
        view.spacing = spacing
        return view
    }
}
