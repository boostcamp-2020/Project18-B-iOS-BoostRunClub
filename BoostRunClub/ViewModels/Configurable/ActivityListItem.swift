//
//  ActivityListItem.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Foundation

struct ActivityListItem {
    let total: ActivityTotalConfig
    let items: [Activity]
}

extension ActivityListItem: Comparable {
    static func == (lhs: ActivityListItem, rhs: ActivityListItem) -> Bool {
        lhs.total.totalRange.start == rhs.total.totalRange.start
    }

    static func < (lhs: ActivityListItem, rhs: ActivityListItem) -> Bool {
        lhs.total.totalRange.start < rhs.total.totalRange.start
    }
}
