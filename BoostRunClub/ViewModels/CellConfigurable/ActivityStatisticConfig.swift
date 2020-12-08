//
//  ActivityStatistic.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

struct ActivityStatisticConfig {
    let filterType: ActivityFilterType
    let period: String
    let distance: String
    let numRunning: String
    let avgPace: String
    let runningTime: String
    let elevation: String

    init(
        filterType: ActivityFilterType = .week,
        period: String = "",
        distance: Double = 0,
        numRunning: Int = 0,
        avgPace: Int = 0,
        runningTime: Double = 0,
        elevation: Int = 0
    ) {
        self.filterType = filterType
        self.period = period // year - ~년 통계, 총 활동 통계
        self.distance = String(format: "%.2fkm/러닝", distance / 1000)
        self.numRunning = "\(numRunning)러닝/주"
        self.avgPace = String(format: "%d'%d\"", avgPace / 60, avgPace % 60)
        self.runningTime = TimeInterval(runningTime).formattedString + "/러닝"
        self.elevation = "\(elevation) m"
    }
}
