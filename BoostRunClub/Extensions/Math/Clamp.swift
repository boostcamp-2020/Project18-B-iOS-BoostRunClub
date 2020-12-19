//
//  Clamp.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/13.
//

import Foundation

func clamped<T>(value: T, minValue: T, maxValue: T) -> T where T: Comparable {
    return max(minValue, min(value, maxValue))
}
