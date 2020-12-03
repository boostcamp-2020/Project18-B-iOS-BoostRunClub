//
//  TimeBaseAnimation.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/04.
//

import UIKit

class TimeBaseAnimation: Animator {
    enum Constant {
        static let normalFlow: Double = 1
        static let backingFlow: Double = -1
    }

    var duration: Double = 0.0
    var flowStyle: AnimationFlow
    private var lastUpdatedTime: Double = 0.0
    private var elapsedTime: Double = 0.0
    private var flowDirection: Double = Constant.normalFlow
    private var state: AnimationState = .notRunning
    private lazy var disPlayLink = CADisplayLink(target: self, selector: #selector(updateTime))
    private(set) weak var targetView: UIView!

    var completion: (() -> Void)?

    init(target: UIView, flow: AnimationFlow = .normal, duration: Double = 1) {
        targetView = target
        flowStyle = flow
        self.duration = duration
    }

    private var progress: Double = 0.0 {
        didSet {
            update(to: progress)
        }
    }

    func setProgress(to progress: Double) {
        self.progress = clamped(value: progress, minValue: 0, maxValue: 1)
    }

    func start() {
        switch state {
        case .notRunning:
            lastUpdatedTime = Date.timeIntervalSinceReferenceDate
            flowDirection = Constant.normalFlow
            state = .running
            disPlayLink.add(to: RunLoop.main, forMode: .default)
        case .running:
            flowDirection = Constant.normalFlow
        }
    }

    func stop() {
        switch flowStyle {
        case .normal:
            forceStop()
        case .backing:
            flowDirection = Constant.backingFlow
        }
    }

    func forceStop() {
        disPlayLink.remove(from: RunLoop.main, forMode: .default)
        state = .notRunning
    }

    func pasue() {
        disPlayLink.isPaused = true
    }

    func resume() {
        disPlayLink.isPaused = false
    }

    @objc
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let newElapsedTime = elapsedTime + flowDirection * (currentTime - lastUpdatedTime)
        elapsedTime = clamped(value: newElapsedTime, minValue: 0, maxValue: duration)
        lastUpdatedTime = currentTime
        update(to: elapsedTime / duration)
    }

    func update(to progress: Double) {
        print(progress)
        switch flowStyle {
        case .normal:
            if progress >= 1 {
                forceStop()
                completion?()
            }
        case .backing:
            if progress >= 1 {
                flowDirection = Constant.backingFlow
                completion?()
            } else if progress <= 0, flowDirection == Constant.backingFlow {
                forceStop()
            }
        }
    }
}
