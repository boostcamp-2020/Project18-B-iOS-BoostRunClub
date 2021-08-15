//
//  RunningEvent.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/14.
//

import Foundation

enum RunningEvent {
    case start, resume, pause, stop, goal(String)

    var text: String {
        switch self {
        case .start:
            return "Welcome to Boost Run Club. Starting Workout."
        case .resume:
            return "Resume Workout."
        case .pause:
            return "Pause Workout"
        case .stop:
            return "Ending Workout. Great job today."
        case let .goal(text):
            return text
        }
    }
}
