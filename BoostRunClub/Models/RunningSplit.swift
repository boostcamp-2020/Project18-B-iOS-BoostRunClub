//
//  RunningSplit.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Foundation

struct RunningSplit {
    var activityUUID: UUID?
    var avgBPM: Int = 0
    var avgPace: Int = 0
    var distance: Double = 0
    var elevation: Int = 0
    var runningSlices = [RunningSlice]()
}
