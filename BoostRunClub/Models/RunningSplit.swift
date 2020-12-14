//
//  RunningSplit.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Foundation

struct RunningSplit: Codable {
    var avgBPM: Int = 0
    var avgPace: Int = 0
    var distance: Double = 0
    var elevation: Int = 0
    var runningSlices = [RunningSlice]()

    mutating func setupSplit(bpm: Int, avgPace: Int, elevation: Int) {
        avgBPM = bpm
        self.avgPace = avgPace
        self.elevation = elevation
        distance = runningSlices.reduce(into: Double(0)) { $0 += $1.distance }
    }
}
