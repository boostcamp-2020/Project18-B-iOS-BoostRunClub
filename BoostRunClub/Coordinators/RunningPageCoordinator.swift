//
//  RunningPageCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol RunningPageCoordinatorProtocol: Coordinator {
    var runningPageController: RunningPageViewController { get set }
}

final class RunningPageCoordinator: NSObject, RunningPageCoordinatorProtocol {
    var runningPageController = RunningPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        prepareRunningPageController()
    }

    private func prepareRunningPageController() {
        childCoordinators = [
            RunningMapCoordinator(UINavigationController()),
            RunningInfoCoordinator(UINavigationController()),
            SplitsCoordinator(UINavigationController()),
        ]

        childCoordinators.forEach { $0.start() }
        runningPageController.setPages(childCoordinators.map { $0.navigationController })
        navigationController.viewControllers = [runningPageController]
    }

    deinit {
        print("finished \(self)")
    }
}
