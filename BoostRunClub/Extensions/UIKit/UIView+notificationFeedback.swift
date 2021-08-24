//
//  UIView+otificationFeedback.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/03.
//

import UIKit

extension UIView {
    func notificationFeedback() {
        print("\(#function), \(Date())")
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
    }
}
