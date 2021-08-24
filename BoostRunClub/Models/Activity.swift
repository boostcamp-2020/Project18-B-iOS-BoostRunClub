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
    var finishedAt: Date
    var uuid: UUID
    var elevation: Double

    init?(
        avgPace: Int,
        distance: Double,
        duration: Double,
        elevation: Double,
        thumbnail: Data?,
        createdAt: Date?,
        finishedAt: Date?,
        uuid: UUID?
    ) {
        guard
            let createdAt = createdAt,
            let finishedAt = finishedAt,
            let uuid = uuid
        else { return nil }
        self.avgPace = avgPace
        self.distance = distance
        self.duration = duration
        self.elevation = elevation
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.finishedAt = finishedAt
        self.uuid = uuid
    }

    init(
        avgPace: Int,
        distance: Double,
        duration: Double,
        elevation: Double,
        thumbnail: Data?,
        createdAt: Date,
        finishedAt: Date,
        uuid: UUID
    ) {
        self.avgPace = avgPace
        self.distance = distance
        self.duration = duration
        self.elevation = elevation
        self.thumbnail = thumbnail
        self.createdAt = createdAt
        self.finishedAt = finishedAt
        self.uuid = uuid
    }
}

extension Activity: Comparable {
    static func < (lhs: Activity, rhs: Activity) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
}

extension Activity {
    var titleText: String {
        "\(createdAt.toDayOfWeekString) \(createdAt.period) 러닝 "
    }

    func dateText(with date: Date) -> String {
        if Date.isSameWeek(date: createdAt, dateOfWeek: date) {
            return createdAt.toDayOfWeekString
        } else {
            return createdAt.toYMDString
        }
    }

    // TODO: avgPace, distance, time 등 단위 변환이 겹치는 것 공통으로 처리하도록 하기
    var avgPaceText: String {
        String(format: "%d'%d\"", avgPace / 60, avgPace % 60)
    }

    var distanceText: String {
        String(format: "%.2f", distance / 1000)
    }

    var runningTimeText: String {
        TimeInterval(duration).fullFormattedString
    }

    var elapsedTimeText: String {
        (finishedAt.timeIntervalSinceReferenceDate - createdAt.timeIntervalSinceReferenceDate).fullFormattedString
    }
}
