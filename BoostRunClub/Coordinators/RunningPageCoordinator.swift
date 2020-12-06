//
//  RunningPageCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

protocol RunningPageCoordinatorProtocol {}

final class RunningPageCoordinator: BasicCoordinator, RunningPageCoordinatorProtocol {
    let factory: RunningPageContainerFactory

    init(navigationController: UINavigationController, factory: RunningPageContainerFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        prepareRunningPageController()
    }

    private func prepareRunningPageController() {
        childCoordinators = [
            RunningMapCoordinator(navigationController: UINavigationController()),
            RunningCoordinator(navigationController: UINavigationController()),
            SplitsCoordinator(navigationController: UINavigationController()),
        ]
        childCoordinators.forEach { $0.start() }

        let runningPageVM = factory.makeRunningPageVM()
        let runningPageVC = factory.makeRunningPageVC(with: runningPageVM, viewControllers: childCoordinators.map { $0.navigationController })

        navigationController.viewControllers = [runningPageVC]
    }

    deinit {
        print("finished \(self)")
    }
}
