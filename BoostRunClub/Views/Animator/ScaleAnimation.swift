//
//  ScaleAnimation.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/04.
//

import UIKit

class ScaleAnimation: TimeBaseAnimation {
    let startScale: CGFloat
    let endScale: CGFloat

    init(
        target: UIView,
        duration: Double,
        flow: AnimationFlow,
        startScale: CGFloat = 1,
        endScale: CGFloat,
        completion: (() -> Void)? = nil
    ) {
        self.startScale = startScale
        self.endScale = endScale
        super.init(target: target, flow: flow, duration: duration)

        self.completion = completion
    }

    override func update(to progress: Double) {
        super.update(to: progress)
        let targetScale = startScale + (endScale - startScale) * CGFloat(progress)
        targetView.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
    }
}
