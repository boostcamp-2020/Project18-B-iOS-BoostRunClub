//
//  RunningSplit.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Foundation

struct RunningSplit {
    var activityUUID: UUID
    var avgBPM: Int = 0
    var avgPace: Int = 0
    var distance: Double = 0
    var elevation: Int = 0
    var runningSlices = [RunningSlice]()

    init?(activityUUID: UUID?, avgBPM: Int, avgPace: Int, distance: Double, elevation: Int, runningSlices: [RunningSlice]) {
        guard let activityUUID = activityUUID else { return nil }
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.avgPace = avgPace
        self.distance = distance
        self.elevation = elevation
        self.runningSlices = runningSlices
    }

    init(activityUUID: UUID, avgBPM: Int, avgPace: Int, distance: Double, elevation: Int, runningSlices: [RunningSlice]) {
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.avgPace = avgPace
        self.distance = distance
        self.elevation = elevation
        self.runningSlices = runningSlices
    }

    init() {
        activityUUID = UUID()
    }
}
