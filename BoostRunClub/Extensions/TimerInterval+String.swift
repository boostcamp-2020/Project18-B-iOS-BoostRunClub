//
//  TimerInterval+String.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Foundation

extension TimeInterval {
    var formattedString: String {
        let interval = Int(self)
        let times = (interval / 60) / 60
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d:%02d", times, minutes, seconds)
    }
}
