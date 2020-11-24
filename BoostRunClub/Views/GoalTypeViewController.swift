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
    var completion: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let size = CGSize(width: bounds.width,
                          height: bounds.height / 2)
        let origin = CGPoint(x: 0, y: bounds.height)
        subView = UIView(frame: CGRect(origin: origin, size: size))
        subView.backgroundColor = .red
        view.addSubview(subView)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.subView.frame.origin.y = self.bounds.height / 2
        }
    }
}

// MARK: - Actions

extension GoalTypeViewController {
    @objc
    func didTapBackgroundView() {
        UIView.animate(withDuration: 1) {
            [weak self] in
            guard let self = self else { return }
            self.subView.frame.origin.y = self.bounds.height
        } completion: { _ in
            // TODO: - 선택된 Goal로 completion 매개변수 전달하기
            self.completion?(0)
            self.dismiss(animated: false, completion: nil)
        }
    }
}
