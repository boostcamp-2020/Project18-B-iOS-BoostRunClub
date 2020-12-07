//
//  ActivityTotal.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

struct ActivityTotalConfig {
    let filterType: ActivityFilterType
    let period: String
    let distance: String
    let numRunning: String
    let avgPace: String
    let runningTime: String

    init(
        filterType: ActivityFilterType = .week,
        period: String = "",
        distance: Double = 0,
        numRunning: Int = 0,
        avgPace: Int = 0,
        runningTime: Double = 0
    ) {
        self.filterType = filterType
        self.period = period // 주: 날짜 or 이번주 or 저번주, 월: yyyy년 mm월, 년: yyyy년, 전체: 2020년 ...
        self.distance = String(format: "%.2", distance)
        self.numRunning = "\(numRunning)"
        self.avgPace = String(format: "%d'%d\"", avgPace / 60, avgPace % 60)
        self.runningTime = TimeInterval(runningTime).formattedString
    }
}
