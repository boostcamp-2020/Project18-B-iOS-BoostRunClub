//
//  Activity.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import Foundation

struct Activity {
    var avgPace: Int
    var distance: Double
    var duration: Double
    var thumbnail: Data?
    var createdAt: Date?
    var uuid: UUID?
}

extension Activity {
    init(zActivity: ZActivity) {
        self.init(avgPace: Int(zActivity.avgPace),
                  distance: zActivity.distance,
                  duration: zActivity.duration,
                  thumbnail: zActivity.thumbnail,
                  createdAt: zActivity.createdAt,
                  uuid: zActivity.uuid)
    }
}
