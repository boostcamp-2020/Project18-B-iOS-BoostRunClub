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
                    start: activities.last?.createdAt ?? activities.first!.createdAt,
                    end: activities.first!.createdAt
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

    func rangeDescription(at range: DateRange, from date: Date = Date()) -> String {
        switch self {
        case .week:
            if Date.isSameWeek(date: range.start, dateOfWeek: date) {
                return "이번 주"
            } else if
                let lastWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: date),
                Date.isSameWeek(date: range.start, dateOfWeek: lastWeekDate)
            {
                return "저번 주"
            }

            if Date.isSameYear(date: range.start, dateOfYear: date) {
                return range.start.toMDString + "~" + range.end.toMDString
            }
            return range.start.toYMDString + "~" + range.end.toYMDString
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
