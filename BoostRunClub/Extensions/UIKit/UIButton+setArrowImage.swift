//
//  UIButton+setArrowImage.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/15.
//

import UIKit

extension UIButton {
    enum ArrowDirection: String {
        case left, right
    }

    func setArrowImage(dir: ArrowDirection, color: UIColor = .black) {
        let arrow = UIImage(systemName: "arrow.\(dir.rawValue)")
        setImage(arrow, for: .normal)
        switch dir {
        case .left:
            semanticContentAttribute = .forceLeftToRight
            contentEdgeInsets.left = 20
            contentEdgeInsets.right = 30
            titleEdgeInsets.left = 5
            titleEdgeInsets.right = -5

        case .right:
            semanticContentAttribute = .forceRightToLeft
            contentEdgeInsets.left = 30
            contentEdgeInsets.right = 20
            titleEdgeInsets.left = -5
            titleEdgeInsets.right = 5
        }
        tintColor = color
    }
}
