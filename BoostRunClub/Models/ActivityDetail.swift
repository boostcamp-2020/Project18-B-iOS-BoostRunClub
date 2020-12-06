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
