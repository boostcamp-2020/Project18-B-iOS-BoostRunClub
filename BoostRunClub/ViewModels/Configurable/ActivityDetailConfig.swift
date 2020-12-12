//
//  ActivityDetailConfig.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/13.
//

import CoreLocation
import Foundation

struct ActivityDetailConfig {
    let titleDate: String
    let title: String

    let distance: Double
    let avgPace: String
    let runningTime: String
    let calorie: Int
    let elevation: Int
    let avgBPM: Int
    let cadence: Int

    let locations: [Location]
    let splits: [RunningSplit]

    init(activity: Activity, detail: ActivityDetail) {
        let timeTexts = activity.createdAt.toYMDHMString.components(separatedBy: " ")
        let periodText = activity.createdAt.period
        titleDate = "\(timeTexts[0]) \(periodText) \(timeTexts[1])"
        title = "\(activity.createdAt.toDayOfWeekString) \(periodText) 러닝"

        distance = activity.distance
        avgPace = activity.avgPaceText
        runningTime = activity.runningTimeText
        calorie = detail.calorie
        elevation = Int(activity.elevation)
        avgBPM = detail.avgBPM
        cadence = detail.cadence

        locations = detail.locations
        splits = detail.splits
    }
}
