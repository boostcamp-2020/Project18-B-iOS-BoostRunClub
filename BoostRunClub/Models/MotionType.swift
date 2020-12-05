//
//  MotionActivityType.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Foundation

enum MotionType {
    case walking,
         stationary,
         running,
         automotive,
         cycling,
         unknown

    var METFactor: Double {
        switch self {
        case .running:
            return 1.035
        case .walking:
            return 0.655
        case .cycling:
            return 0.450
        case .unknown:
            return 0
        default:
            return 0
        }
    }
}
