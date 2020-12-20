//
//  Date+String.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension Date {
    typealias YearMonthDay = (year: Int, month: Int, day: Int)
    typealias HourMinSec = (hour: Int, min: Int, sec: Int)

    var toMDString: String {
        DateFormatter.MDFormatter.string(from: self)
    }

    var toYMDHMString: String {
        DateFormatter.YMDHMFormatter.string(from: self)
    }

    var toYMDString: String {
        DateFormatter.YMDFormatter.string(from: self)
    }

    var toYMString: String {
        DateFormatter.YMFormatter.string(from: self)
    }

    var toYString: String {
        DateFormatter.YFormatter.string(from: self)
    }

    var toHMString: String {
        DateFormatter.HMFormatter.string(from: self)
    }

    var toDayOfWeekString: String {
        DateFormatter.KRDayOfWeekFormatter.string(from: self)
    }

    var toMDEString: String {
        DateFormatter.MDEFormatter.string(from: self)
    }

    var toPHM: String {
        period + " " + toHMString
    }

    var yearMonthDay: YearMonthDay? {
        let str = DateFormatter.YMDFormatter.string(from: self)
        let components = str.components(separatedBy: ".")
        guard
            components.count >= 3,
            let year = Int(components[0]),
            let day = Int(components[1]),
            let month = Int(components[2])
        else { return nil }

        return (year, day, month)
    }

    var hourMinSec: HourMinSec? {
        let str = DateFormatter.HMSFormatter.string(from: self)
        let components = str.components(separatedBy: ":")
        guard
            components.count >= 3,
            let hour = Int(components[0]),
            let min = Int(components[1]),
            let sec = Int(components[2])
        else { return nil }

        return (hour, min, sec)
    }

    var period: String {
        guard let hourMinSec = self.hourMinSec else { return "알수없는 시간대" }
        switch hourMinSec.hour {
        case 22 ... 24, 0 ..< 3:
            return "야간"
        case 3 ..< 6:
            return "새벽"
        case 6 ..< 12:
            return "오전"
        case 12 ..< 18:
            return "오후"
        case 18 ..< 22:
            return "저녁"
        default:
            return ""
        }
    }
}
