//
//  Number+Clamp.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/04.
//

import Foundation

func clamped<T>(value: T, minValue: T, maxValue: T) -> T where T: Comparable {
    return min(max(value, minValue), maxValue)
}
