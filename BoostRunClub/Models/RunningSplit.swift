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

extension RunningSplit {
    static var sampleData: [RunningSplit] = {
        var lastIdx = 10
        var data: [RunningSplit] = (1 ... lastIdx).map { idx in
            var split = RunningSplit()
            var slice = RunningSlice()
            slice.startIndex = idx
            split.runningSlices.append(slice)
            split.avgPace = Int.random(in: 1 ... 100)
            split.distance = lastIdx == idx ? 439 : 1000
            return split
        }

        return data
    }()
}
