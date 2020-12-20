//
//  ActivityTotal.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

struct ActivityTotalConfig {
    let filterType: ActivityFilterType
    let period: String
    let selectedRange: DateRange
    let totalRange: DateRange
    let totalDistance: Double
    let numRunning: Int
    let avgPace: Int
    let totalRunningTime: Double
    let totalElevation: Double

    var avgPaceText: String {
        String(format: "%d'%d\"", avgPace / 60, avgPace % 60)
    }

    // Total
    var totalDistanceText: String {
        String(format: "%.2f", totalDistance / 1000)
    }

    var numRunningText: String {
        String(format: "%d", numRunning)
    }

    var totalRunningTimeText: String {
        TimeInterval(totalRunningTime).fullFormattedString
    }

    // Statistic
    var numRunningPerWeekText: String {
        let numberOfWeeks = Date.numberOfWeeks(range: totalRange) ?? 1
        return String(format: "%.2f러닝/주", Double(numRunning) / Double(numberOfWeeks))
    }

    var distancePerRunningText: String {
        guard numRunning > 0 else { return "--" }
        return String(format: "%.2fkm/러닝", (totalDistance / 1000) / Double(numRunning))
    }

    var runningTimePerRunningText: String {
        guard numRunning > 0 else { return "--" }
        return "\(TimeInterval(totalRunningTime / Double(numRunning)).fullFormattedString)/러닝"
    }

    var totalElevationText: String {
        String(format: "%.0f m", totalElevation)
    }

    init(
        period: String = "",
        distance: Double = 0,
        numRunning: Int = 0,
        avgPace: Int = 0,
        runningTime: Double = 0,
        elevation: Double = 0,
        dateRange: DateRange = DateRange(start: Date(), end: Date())
    ) {
        self.period = period
        totalDistance = distance
        self.numRunning = numRunning
        self.avgPace = avgPace
        totalRunningTime = runningTime
        totalElevation = elevation
        totalRange = dateRange
        filterType = .week
        selectedRange = dateRange
    }

    init(filterType: ActivityFilterType, filterRange: DateRange, activities: [Activity]) {
        var sumAvgPace: Int = 0
        var sumDuration: Double = 0
        var sumDistance: Double = 0
        var sumElevation: Double = 0

        activities.forEach {
            sumAvgPace += $0.avgPace
            sumDuration += $0.duration
            sumDistance += $0.distance
            sumElevation += $0.elevation
        }
        self.filterType = filterType
        selectedRange = filterRange
        period = filterType.rangeDescription(at: filterRange)
        avgPace = activities.count == 0 ? 0 : sumAvgPace / activities.count

        totalDistance = sumDistance
        totalRunningTime = sumDuration
        numRunning = activities.count
        totalElevation = sumElevation

        if
            let start = activities.first?.createdAt,
            let last = activities.last?.createdAt
        {
            totalRange = DateRange(start: start, end: last)
        } else {
            totalRange = DateRange(start: Date(), end: Date())
        }
    }
}

extension ActivityTotalConfig {}
