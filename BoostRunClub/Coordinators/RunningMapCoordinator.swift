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
    let factory: RunningMapSceneFactory

    init(navigationController: UINavigationController, factory: RunningMapSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showRunningMapViewController()
    }

    func showRunningMapViewController() {
        let runningMapVM = factory.makeRunningMapVM()
        let runningMapVC = factory.makeRunningMapVC(with: runningMapVM)
        navigationController.pushViewController(runningMapVC, animated: true)
    }
}
