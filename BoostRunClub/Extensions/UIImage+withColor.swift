//
//  UIImage+withColor.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

extension UIImage {
    static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        let rect = CGRect(origin: .zero, size: size)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
