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

extension RunningSplit {
    init(zRunningSplit: ZRunningSplit) {
        if
            let data = zRunningSplit.runningSlices as? Data,
            let slices = try? JSONDecoder().decode([RunningSlice].self, from: data)
        {
            runningSlices = slices
        }

        activityUUID = zRunningSplit.activityUUID
        avgBPM = Int(zRunningSplit.avgBPM)
        avgPace = Int(zRunningSplit.avgPace)
        distance = zRunningSplit.distance
        elevation = Int(zRunningSplit.elevation)
    }
}
