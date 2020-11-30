//
//  RunningMapCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol RunningMapCoordinatorProtocol: Coordinator {
    func showRunningMapViewController()
}

final class RunningMapCoordinator: RunningMapCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showRunningMapViewController()
    }

    func showRunningMapViewController() {
        let runningMapVC = RunningMapViewController()
        navigationController.pushViewController(runningMapVC, animated: true)
    }
}
