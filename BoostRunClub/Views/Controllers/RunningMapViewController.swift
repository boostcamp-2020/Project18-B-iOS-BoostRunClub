//
//  RunningMapViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import UIKit

class RunningMapViewController: UIViewController {
    // TODO: vc -  ViewModel - Network, cord, Running
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }

    deinit {
        print("[\(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}
