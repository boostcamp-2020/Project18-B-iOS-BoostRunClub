//
//  ActivityFilterType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

enum ActivityFilterType: Int {
    case week,
         month,
         year,
         all

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

    func groupDateRanges(from dates: [Date]) -> [DateRange] {
        guard !dates.isEmpty else { return [] }

        if self == .all {
            return [DateRange(from: dates.first!, to: dates.last ?? dates.first!)]
        }

        var results = [DateRange]()
        dates.forEach {
            if
                results.isEmpty,
                let range = $0.rangeOf(type: self)
            {
                results.append(range)
            } else if
                let lastRange = results.last,
                !lastRange.contains(date: $0),
                let newRange = $0.rangeOfWeek
            {
                results.append(newRange)
            }
        }
        return results
    }

    func rangeDescription(from range: DateRange) -> String {
        switch self {
        case .week:
            return range.from.toMDString + "~" + range.to.toMDString
        case .month:
            return range.to.toYMString
        case .year:
            return range.to.toYString
        case .all:
            let from = range.from.toYString
            let to = range.to.toYString
            return from == to ? to : from + "-" + to
        }
    }
}
