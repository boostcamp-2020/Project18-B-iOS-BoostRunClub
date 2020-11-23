//
//  GoalTypeViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import UIKit

class GoalTypeViewController: UIViewController {
    var subView: UIView!
    let bounds = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let size = CGSize(width: bounds.width,
                          height: bounds.height / 2)
        let origin = CGPoint(x: 0, y: bounds.height)
        subView = UIView(frame: CGRect(origin: origin, size: size))
        subView.backgroundColor = .red
        view.addSubview(subView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.subView.frame.origin.y = self.bounds.height / 2
        }
    }
}
