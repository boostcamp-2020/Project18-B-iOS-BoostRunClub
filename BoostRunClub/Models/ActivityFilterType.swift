//
//  ActivityFilterType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

enum ActivityFilterType {
    case week, month, year, all

    var name: String {
        switch self {
        case .week:
            return "주"
        case .month:
            return "월"
        case .year:
            return "년"
        case .all:
            return "전체"
        }
    }
}
