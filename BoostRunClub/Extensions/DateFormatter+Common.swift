//
//  DateFormatter.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension DateFormatter {
    static var YMDHMFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}
