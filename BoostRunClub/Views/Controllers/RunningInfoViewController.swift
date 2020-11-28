//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import UIKit

class RunningInfoViewController: UIViewController {
    private var viewModel: RunningViewModelTypes?
    
    
    

    init(with runningViewModel: RunningViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = runningViewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
