//
//  ActivityDetail.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import Foundation

struct ActivityDetail {
    var activityUUID: UUID
    var avgBPM: Int
    var cadence: Int
    var calorie: Int
    var elevation: Int
    var locations: [Location]
    var splits: [RunningSplit]

    init?(
        activityUUID: UUID?,
        avgBPM: Int,
        cadence: Int,
        calorie: Int,
        elevation: Int,
        locations: [Location],
        splits: [RunningSplit]
    ) {
        guard let activityUUID = activityUUID else { return nil }
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.cadence = cadence
        self.calorie = calorie
        self.elevation = elevation
        self.locations = locations
        self.splits = splits
    }

    init(
        activityUUID: UUID,
        avgBPM: Int,
        cadence: Int,
        calorie: Int,
        elevation: Int,
        locations: [Location],
        splits: [RunningSplit]
    ) {
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.cadence = cadence
        self.calorie = calorie
        self.elevation = elevation
        self.locations = locations
        self.splits = splits
    }
}
