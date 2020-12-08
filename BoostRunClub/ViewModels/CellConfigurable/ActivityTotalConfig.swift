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
    let dateRange: DateRange
    let totalDistance: Double
    let numRunning: Int
    let avgPace: Int
    let totalRunningTime: Double
    let totalElevation: Int

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
        TimeInterval(totalRunningTime).formattedString
    }

    // Statistic
    var numRunningPerWeekText: String {
        let numberOfWeeks = Date.numberOfWeeks(range: dateRange) ?? 1
        return String(format: "%.2f러닝/주", Double(numRunning) / Double(numberOfWeeks))
    }

    var distancePerRunningText: String {
        String(format: "%.2fkm/러닝", (totalDistance / 1000) / Double(numRunning))
    }

    var runningTimePerRunningText: String {
        TimeInterval(totalRunningTime / Double(numRunning)).formattedString
    }

    var totalElevationText: String {
        String(format: "%d m", totalElevation)
    }

    init(
        period: String = "",
        distance: Double = 0,
        numRunning: Int = 1,
        avgPace: Int = 0,
        runningTime: Double = 0,
        elevation: Int = 0,
        dateRange: DateRange = DateRange(from: Date(), to: Date())
    ) {
        self.period = period // 주: 날짜 or 이번주 or 저번주, 월: yyyy년 mm월, 년: yyyy년, 전체: 2020년 ...
        totalDistance = distance
        self.numRunning = numRunning
        self.avgPace = avgPace
        totalRunningTime = runningTime
        totalElevation = elevation
        self.dateRange = dateRange
        filterType = .week
    }

    init(filterType: ActivityFilterType, filterRange: DateRange, activities: [Activity]) {
        var sumAvgPace: Int = 0
        var sumDuration: Double = 0
        var sumDistance: Double = 0
        var sumElevation: Int = 0

        activities.forEach {
            sumAvgPace += $0.avgPace
            sumDuration += $0.duration
            sumDistance += $0.distance
            sumElevation += 0
        }
        self.filterType = filterType
        period = filterType.rangeDescription(from: filterRange)
        avgPace = sumAvgPace / activities.count
        totalDistance = sumDistance
        totalRunningTime = sumDuration
        numRunning = activities.count
        totalElevation = sumElevation

        if
            let start = activities.first?.createdAt,
            let last = activities.last?.createdAt
        {
            dateRange = DateRange(from: start, to: last)
        } else {
            dateRange = DateRange(from: Date(), to: Date())
        }
    }
}

extension ActivityTotalConfig {}
