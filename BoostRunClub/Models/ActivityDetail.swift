//
//  ActivityDetail.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import Foundation

struct ActivityDetail {
    var activityUUID: UUID?
    var avgBPM: Int
    var cadence: Int
    var calorie: Int
    var elevation: Int
    var locations: [Location]

    init?(activityUUID: UUID?, avgBPM: Int, cadence: Int, calorie: Int, elevation: Int, locations: [Location]) {
        guard let activityUUID = activityUUID else { return nil }
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.cadence = cadence
        self.calorie = calorie
        self.elevation = elevation
        self.locations = locations
    }

    init(activityUUID: UUID, avgBPM: Int, cadence: Int, calorie: Int, elevation: Int, locations: [Location]) {
        self.activityUUID = activityUUID
        self.avgBPM = avgBPM
        self.cadence = cadence
        self.calorie = calorie
        self.elevation = elevation
        self.locations = locations
    }
}
