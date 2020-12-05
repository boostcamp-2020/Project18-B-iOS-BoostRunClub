//
//  RunningInfoType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Foundation

enum RunningInfoType: CaseIterable {
    case pace, averagePace, bpm, calorie, time, kilometer, cadence, interval, meter

    var initialValue: String {
        switch self {
        case .pace:
            return "0\'00\""
        case .averagePace:
            return "0\'00\""
        case .bpm:
            return "0"
        case .calorie:
            return "0"
        case .time:
            return "00:00"
        case .kilometer:
            return "0"
        case .cadence:
            return "0"
        case .interval:
            return "0"
        case .meter:
            return "0"
        }
    }

    var name: String {
        switch self {
        case .pace:
            return "페이스"
        case .averagePace:
            return "평균 페이스"
        case .bpm:
            return "BPM"
        case .calorie:
            return "칼로리"
        case .time:
            return "시간"
        case .kilometer:
            return "킬로미터"
        case .cadence:
            return "케이던스"
        case .interval:
            return "인터벌"
        case .meter:
            return "미터"
        }
    }

    static func getPossibleTypes(from goalType: GoalType) -> [Self] {
        switch goalType {
        case .distance, .time, .none:
            return RunningInfoType.allCases.filter { $0 != .meter && $0 != .interval }
        case .speed:
            return RunningInfoType.allCases
        }
    }
}

struct RunningInfo {
    let type: RunningInfoType
    let value: String

    init(type: RunningInfoType, value: String) {
        self.type = type
        self.value = value
    }

    init(type: RunningInfoType) {
        self.type = type
        value = type.initialValue
    }
}
