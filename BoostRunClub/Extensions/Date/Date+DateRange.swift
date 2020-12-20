//
//  Date+.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension Date {
    func rangeOf(type: ActivityFilterType) -> DateRange? {
        switch type {
        case .week:
            return rangeOfWeek
        case .month:
            return rangeOfMonth
        case .year:
            return rangeOfYear
        case .all:
            return nil
        }
    }

    var rangeOfWeek: DateRange? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let startOfWeek = calendar.date(from: components),
              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)
        else { return nil }
        return DateRange(start: startOfWeek, end: endOfWeek)
    }

    var rangeOfMonth: DateRange? {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month], from: self)
        var endComponents = DateComponents()
        endComponents.month = 1
        endComponents.second = -1
        guard let startOfMonth = calendar.date(from: startComponents),
              let endOfMonth = calendar.date(byAdding: endComponents, to: startOfMonth)
        else { return nil }

        return DateRange(start: startOfMonth, end: endOfMonth)
    }

    var rangeOfYear: DateRange? {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year], from: self)
        var endComponents = DateComponents()
        endComponents.year = 1
        endComponents.second = -1

        guard let startOfMonth = calendar.date(from: startComponents),
              let endOfMonth = calendar.date(byAdding: endComponents, to: startOfMonth)
        else { return nil }

        return DateRange(start: startOfMonth, end: endOfMonth)
    }

    static func numberOfWeeks(range: DateRange) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfMonth], from: range.start, to: range.end)
        return components.weekOfMonth == 0 ? 1 : components.weekOfMonth
    }

    static func isSameWeek(date: Date, dateOfWeek: Date) -> Bool {
        dateOfWeek.rangeOfWeek?.contains(date: date) ?? false
    }

    static func isSameYear(date: Date, dateOfYear: Date) -> Bool {
        dateOfYear.rangeOfYear?.contains(date: date) ?? false
    }
}
