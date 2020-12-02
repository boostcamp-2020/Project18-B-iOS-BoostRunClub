//
//  RunningMapCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol RunningMapCoordinatorProtocol {
    func showRunningMapViewController()
}

final class RunningMapCoordinator: BasicCoordinator, RunningMapCoordinatorProtocol {
    override func start() {
        showRunningMapViewController()
    }

    func showRunningMapViewController() {
        let runningMapVC = RunningMapViewController()
        navigationController.pushViewController(runningMapVC, animated: true)
    }
}
