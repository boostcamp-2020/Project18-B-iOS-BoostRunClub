//
//  Date+String.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension Date {
    typealias YearMonthDay = (year: Int, month: Int, day: Int)

    var toMDString: String {
        DateFormatter.MDFormatter.string(from: self)
    }

    var toYMDHString: String {
        DateFormatter.YMDHMFormatter.string(from: self)
    }

    var toYMString: String {
        DateFormatter.YMFormatter.string(from: self)
    }

    var toYString: String {
        DateFormatter.YFormatter.string(from: self)
    }

    var yearMonthDay: YearMonthDay? {
        let str = DateFormatter.YMDFormatter.string(from: self)
        let components = str.components(separatedBy: "-")
        guard
            components.count >= 3,
            let year = Int(components[0]),
            let day = Int(components[1]),
            let month = Int(components[2])
        else { return nil }

        return (year, day, month)
    }
}
