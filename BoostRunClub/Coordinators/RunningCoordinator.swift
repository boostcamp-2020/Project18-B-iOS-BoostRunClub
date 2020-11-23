//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol RunningCoordinatorProtocol: Coordinator {}

final class RunningCoordinator: RunningCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showRunningViewController()
    }

    func showRunningViewController() {
        let runningVC = RunningViewController()

        navigationController.pushViewController(runningVC, animated: true)
    }
}
