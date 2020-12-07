//
//  ActivityTotal.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

struct ActivityTotal {
    let period: String
    let distance: String
    let numRunning: Int
    let avgPace: String
    let runningTime: String
    
    init(
        period: String = "",
        distance: String = "",
        numRunning: Int = 0,
        avgPace: String = "",
        runningTime: String = "")
    {
        self.period = period
        self.distance = distance
        self.numRunning = numRunning
        self.avgPace = avgPace
        self.runningTime = runningTime
    }
    
}
