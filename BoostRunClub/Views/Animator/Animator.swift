//
//  Animator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/04.
//

import UIKit

protocol Animator {
    func start()
    func stop()
    func pasue()
    func resume()
    func forceStop()
    func setProgress(to progress: Double)
}

enum AnimationState {
    case running, notRunning
}

enum AnimationFlow {
    case normal, backing
}
