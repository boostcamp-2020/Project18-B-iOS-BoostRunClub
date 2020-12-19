//
//  CircleLongPressButton.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/13.
//

import Combine
import UIKit

class CircleLongPressButton: CircleButton {
    private(set) var didTapButtonSignal = PassthroughSubject<Void, Never>()

    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
    private var lastUpdatedTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var progress: Double = 0
    private var direction: Double = 1

    private let duration: Double

    private let targetScaleRatio: CGFloat

    init(with buttonStyle: CircleButton.Style, scaleRatio: CGFloat = 4, duration: Double = 1) {
        self.duration = duration
        targetScaleRatio = scaleRatio
        super.init(with: buttonStyle)
        commonInit()
    }

    required init?(coder: NSCoder) {
        duration = 3
        targetScaleRatio = 1.3
        super.init(coder: coder)
        commonInit()
    }

    @objc
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let interval = currentTime - lastUpdatedTime
        lastUpdatedTime = currentTime

        elapsedTime = clamped(value: elapsedTime + direction * interval, minValue: 0, maxValue: duration)
        updateProgress(CGFloat(elapsedTime / duration))
    }

    func updateProgress(_ progress: CGFloat) {
        let iProgress = 1 - progress
        let newProgress = 3 * progress * iProgress * iProgress
            + 3 * progress * progress * iProgress
            + progress * progress * progress

        let newScaleRatio = 1 + (targetScaleRatio - 1) * newProgress
        transform = CGAffineTransform(scaleX: newScaleRatio, y: newScaleRatio)

        if newProgress >= 1 {
            direction = -1
            didTapButtonSignal.send()
        }

        if newProgress <= 0 {
            displayLink.remove(from: RunLoop.main, forMode: .common)
            elapsedTime = 0
        }
    }
}

// MARK: - Actions

extension CircleLongPressButton {
    @objc
    func didTouchDown() {
        if elapsedTime == 0 {
            displayLink.add(to: RunLoop.main, forMode: .common)
            lastUpdatedTime = Date.timeIntervalSinceReferenceDate
        }

        direction = 1
    }

    @objc
    func didTouchRelease() {
        direction = -1
    }
}

// MARK: - Configure

extension CircleLongPressButton {
    private func commonInit() {
        addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        addTarget(self, action: #selector(didTouchRelease), for: .touchUpInside)
        addTarget(self, action: #selector(didTouchRelease), for: .touchUpOutside)
    }
}
