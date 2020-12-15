//
//  UIColor+RGBA.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/15.
//

import UIKit

typealias ColorRGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

extension UIColor {
    var rgba: ColorRGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}
