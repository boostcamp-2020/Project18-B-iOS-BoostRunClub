//
//  RunningInfoType.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Foundation

enum RunningInfoType: CaseIterable {
    case time, pace, cadence, bpm, calorie, averagePace, kilometer, interval, meter
}

struct RunningInfo {
    let type: RunningInfoType
    let value: String
}
