//
//  RunningInfoType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Foundation

enum RunningInfoType: CaseIterable {
//    static var allCases: [RunningInfoType] {
//        return [
//            pace("0\'00\""),
//            averagePace("0\'00\""),
//            bpm("0"),
//            calorie("0"),
//            time("00:00"),
//            kilometer("0.00"),
//            cadence("0"),
//            interval,
//            meter,
//        ]
//    }

    case pace, averagePace, bpm, calorie, time, kilometer, cadence, interval, meter
//    case pace(String),
//         averagePace(String),
//         bpm(String),
//         calorie(String),
//         time(String),
//         kilometer(String),
//         cadence(String),
//         interval,
//         meter

//    var value: String {
//        switch self {
//        case let .pace(value), let
//            .averagePace(value), let
//            .bpm(value), let
//            .calorie(value), let
//            .time(value), let
//            .kilometer(value), let
//            .cadence(value):
//            return value
//        case .interval, .meter:
//            return ""
//        }
//    }

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

//    var index: Int {
//        switch self {
//        case .pace:
//            return 0
//        case .averagePace:
//            return 1
//        case .bpm:
//            return 2
//        case .calorie:
//            return 3
//        case .time:
//            return 4
//        case .kilometer:
//            return 5
//        case .cadence:
//            return 6
//        case .interval:
//            return 7
//        case .meter:
//            return 8
//        }
//    }

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
