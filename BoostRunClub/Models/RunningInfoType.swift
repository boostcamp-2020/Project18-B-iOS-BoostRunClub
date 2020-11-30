//
//  RunningInfoType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Foundation

enum RunningInfoType: CaseIterable {
    static var allCases: [RunningInfoType] {
        return [
            pace("0\'00\""),
            averagePace("0\'00\""),
            bpm("0"),
            calorie("0"),
            time("00:00"),
            kilometer("0.00"),
            cadence("0"),
            interval,
            meter,
        ]
    }

    case pace(String),
         averagePace(String),
         bpm(String),
         calorie(String),
         time(String),
         kilometer(String),
         cadence(String),
         interval,
         meter

    var value: String {
        switch self {
        case let .pace(value), let
            .averagePace(value), let
            .bpm(value), let
            .calorie(value), let
            .time(value), let
            .kilometer(value), let
            .cadence(value):
            return value
        case .interval, .meter:
            return ""
        }
    }

    var index: Int {
        switch self {
        case .pace:
            return 0
        case .averagePace:
            return 1
        case .bpm:
            return 2
        case .calorie:
            return 3
        case .time:
            return 4
        case .kilometer:
            return 5
        case .cadence:
            return 6
        case .interval:
            return 7
        case .meter:
            return 8
        }
    }
}
