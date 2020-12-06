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
}

extension ActivityDetail {
    init(zActivityDetail: ZActivityDetail) {
        var locations: [Location]?
        if let data = zActivityDetail.locations {
            locations = try? JSONDecoder().decode([Location].self, from: data)
        }

        self.init(activityUUID: zActivityDetail.activityUUID,
                  avgBPM: Int(zActivityDetail.avgBPM),
                  cadence: Int(zActivityDetail.cadence),
                  calorie: Int(zActivityDetail.calorie),
                  elevation: Int(zActivityDetail.elevation),
                  locations: locations ?? [])
    }
}
