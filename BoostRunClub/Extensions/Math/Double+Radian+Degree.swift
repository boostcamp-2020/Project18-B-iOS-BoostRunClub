//
//  Double+Radian+Degree.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/19.
//

import Foundation

extension Double {
    static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }

    static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
}
