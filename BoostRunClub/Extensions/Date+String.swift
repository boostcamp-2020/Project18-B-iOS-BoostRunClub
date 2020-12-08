//
//  Date+String.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

extension Date {
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
}
