//
//  UINavigationController+setStatusBar.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/13.
//

import UIKit

extension UINavigationController {
    // 사용하는 뷰컨에서 viewDidDisappear 시 removeFromParent로 없애줄 것
    func setStatusBar(backgroundColor: UIColor) -> UIView {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
        return statusBarView
    }
}
