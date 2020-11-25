//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/25.
//

import UIKit

protocol RunningCoordinatorProtocol: Coordinator {
    func showRunningViewController()
}

final class RunningCoordinator: RunningCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    var type: CoordinatorType { .running }

    func start() {
        showRunningViewController()
    }

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showRunningViewController() {
        let runningVC = RunningViewController()
        navigationController.pushViewController(runningVC, animated: false)
    }
}
