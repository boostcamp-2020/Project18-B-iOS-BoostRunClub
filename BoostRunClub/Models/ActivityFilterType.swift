//
//  ActivityFilterType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

enum ActivityFilterType: Int {
    case week, month, year, all

    func groupDateRanges(from activities: [Activity]) -> [DateRange] {
        guard !activities.isEmpty else { return [] }

        if self == .all {
            return [
                DateRange(
                    start: activities.first!.createdAt,
                    end: activities.last?.createdAt ?? activities.first!.createdAt
                ),
            ]
        }

        return activities
            .reduce(into: [DateRange]()) { result, activity in
                if
                    result.isEmpty,
                    let range = activity.createdAt.rangeOf(type: self)
                {
                    result.append(range)
                } else if
                    let lastRange = result.last,
                    !lastRange.contains(date: activity.createdAt),
                    let newRange = activity.createdAt.rangeOf(type: self)
                {
                    result.append(newRange)
                }
            }
    }

//    func groupDateRanges(from dates: [Date]) -> [DateRange] {
//        guard !dates.isEmpty else { return [] }
//
//        if self == .all {
//            return [DateRange(start: dates.first!, end: dates.last ?? dates.first!)]
//        }
//
//        var results = [DateRange]()
//        dates.forEach {
//            if
//                results.isEmpty,
//                let range = $0.rangeOf(type: self)
//            {
//                results.append(range)
//            } else if
//                let lastRange = results.last,
//                !lastRange.contains(date: $0),
//                let newRange = $0.rangeOf(type: self)
//            {
//                results.append(newRange)
//            }
//        }
//        return results
//    }

    func rangeDescription(from range: DateRange) -> String {
        switch self {
        case .week:
            return range.start.toMDString + "~" + range.end.toMDString
        case .month:
            return range.end.toYMString
        case .year:
            return range.end.toYString
        case .all:
            let from = range.start.toYString
            let end = range.end.toYString
            return from == end ? end : from + "-" + end
        }
    }
}
