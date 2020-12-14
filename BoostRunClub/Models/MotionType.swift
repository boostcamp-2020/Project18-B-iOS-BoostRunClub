//
//  MotionType.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/15.
//

import Foundation

enum MotionType {
    case running, standing

    var METFactor: Double {
        switch self {
        case .running:
            return 1.035
        case .standing:
            return 0
//        case _ where walking:
//            return 0.655
        }
    }
}
