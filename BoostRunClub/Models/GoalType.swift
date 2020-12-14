//
//  GoalType.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/26.
//

enum GoalType: Int {
    case distance, time, speed, none

    var description: String {
        switch self {
        case .distance:
            return "거리"
        case .time:
            return "시간"
        case .speed:
            return "속도"
        case .none:
            return "목표 설정"
        }
    }

    var initialValue: String {
        switch self {
        case .distance:
            return "5.00"
        case .time:
            return "00:30"
        case .speed, .none:
            return ""
        }
    }

    var unit: String {
        switch self {
        case .distance:
            return "킬로미터"
        case .time:
            return "시간 : 분"
        case .speed, .none:
            return ""
        }
    }
}

struct GoalInfo: Equatable {
    let type: GoalType
    let value: String
}
