//
//  Location.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import Foundation

struct Location: Codable {
    let longitude: Double = 0
    let latitude: Double = 0
    let altitude: Double = 0
    let speed: Int = 0
    let timestamp = Date()
}
