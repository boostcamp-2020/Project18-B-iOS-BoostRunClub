//
//  UIImage+CustomAnnotation.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/13.
//

import Foundation
import UIKit

extension UIImage {
    static func customSplitAnnotation(type: CustomAnnotationType, title: String = " ", color: UIColor = .white) -> UIImage {
        let label = UILabel()
        label.textColor = .black
        label.text = title
        label.textAlignment = .center

        switch type {
        case .split:
            label.frame.size = CGSize(width: label.intrinsicContentSize.width + CGFloat(23), height: label.intrinsicContentSize.height)
            label.backgroundColor = color
            label.layer.cornerRadius = label.bounds.height * 6 / 10
        case .point:
            label.frame.size = CGSize(width: CGFloat(10), height: CGFloat(10))
            label.layer.cornerRadius = label.bounds.height / 2
            label.layer.borderWidth = 5
            label.layer.borderColor = UIColor.white.cgColor
            label.backgroundColor = color
        }

        label.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        return image
    }

    enum CustomAnnotationType {
        case point, split
    }
}
