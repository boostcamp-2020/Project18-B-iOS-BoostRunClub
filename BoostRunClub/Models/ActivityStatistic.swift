//
//  ActivityStatistic.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

struct ActivityStatistic {
    let period: String
    let distance: String
    let numRunning: Int
    let avgPace: String
    let runningTime: String
    let elevation: Int
    
    init(
        period: String = "",
        distance: String = "",
        numRunning: Int = 0,
        avgPace: String = "",
        runningTime: String = "",
        elevation: Int = 0)
    {
        self.period = period
        self.distance = distance
        self.numRunning = numRunning
        self.avgPace = avgPace
        self.runningTime = runningTime
        self.elevation = elevation
    }
}
