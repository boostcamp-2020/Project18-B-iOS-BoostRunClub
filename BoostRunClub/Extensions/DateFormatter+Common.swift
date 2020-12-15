//
//  DateFormatter.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension DateFormatter {
    static var YMDHMFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy.MM.dd HH:mm"
        return fmt
    }()

    static var MDFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM.dd."
        return fmt
    }()

    static var YMFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy년 MM월"
        return fmt
    }()

    static var YFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy년"
        return fmt
    }()

    static var YMDFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy.MM.dd"
        return fmt
    }()

    static var HMSFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        return fmt
    }()

    static var HMFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mm"
        return fmt
    }()

    static var MDEFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko")
        fmt.dateFormat = "M월 d일 EEEE"
        return fmt
    }()

    static var KRDayOfWeekFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko")
        fmt.dateFormat = "EEEE"
        return fmt
    }()
}
