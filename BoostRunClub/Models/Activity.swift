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
    var createdAt: Date
    var uuid: UUID
    var elevation: Double

    init?(avgPace: Int, distance: Double, duration: Double, elevation: Double, thumbnail: Data?, createdAt: Date?, uuid: UUID?) {
        guard
            let createdAt = createdAt,
            let uuid = uuid
        else { return nil }
        self.avgPace = avgPace
        self.distance = distance
        self.duration = duration
        self.elevation = elevation
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.uuid = uuid
    }

    init(avgPace: Int, distance: Double, duration: Double, elevation: Double, thumbnail: Data?, createdAt: Date, uuid: UUID) {
        self.avgPace = avgPace
        self.distance = distance
        self.duration = duration
        self.elevation = elevation
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.uuid = uuid
    }
}

// ERASE! : dummy 데이터용
extension Activity {
    init(date: Date) {
        self.init(avgPace: Int.random(in: 500 ... 3000),
                  distance: Double.random(in: 800 ... 9000),
                  duration: Double.random(in: 3000 ... 9000),
                  elevation: Double.random(in: -10 ... 100),
                  thumbnail: nil,
                  createdAt: date,
                  uuid: UUID())
    }
}
