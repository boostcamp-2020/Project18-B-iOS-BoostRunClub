//
//  RunningInfoCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol RunningInfoCoordinatorProtocol: Coordinator {
    func showRunningInfoViewController()
}

final class RunningInfoCoordinator: RunningInfoCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showRunningInfoViewController()
    }

    func showRunningInfoViewController() {
        let runningInfoVC = RunningInfoViewController(with: RunningInfoViewModel(goalType: .none, goalValue: ""))
        navigationController.pushViewController(runningInfoVC, animated: true)
    }
}
