//
//  DateRange.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

struct DateRange {
    let start: Date
    let end: Date
}

extension DateRange {
    func contains(date: Date) -> Bool {
        (start ... end) ~= date
    }
}
