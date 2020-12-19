//
//  UILabel+Make.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

extension UILabel {
    static func makeBold(text: String = "Value", size: CGFloat = 20, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.textColor = color
        label.text = text
        return label
    }

    static func makeNormal(text: String = "Value", size: CGFloat = 17, color: UIColor = .systemGray) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = color
        label.text = text
        return label
    }
}
