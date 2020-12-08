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
    init(date: Date?) {
        self.init(avgPace: Int.random(in: 500 ... 3000),
                  distance: Double.random(in: 800 ... 9000),
                  duration: Double.random(in: 3000 ... 9000),
                  thumbnail: nil,
                  createdAt: date,
                  uuid: nil)
    }
}
