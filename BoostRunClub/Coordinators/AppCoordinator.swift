//
//  AppCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?

    var type: CoordinatorType { .app }

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    var cancellable: AnyCancellable?

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)

        cancellable = NotificationCenter.default
            .publisher(for: .showRunningScene)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.clear()
                self.showRunningFlow()
            }
    }

    func start() {
        showMainFlow()
    }

    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    func showMainFlow() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController)
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }

    func showRunningFlow() {
        let runningCoordinator = RunningCoordinator(navigationController)
        childCoordinators.append(runningCoordinator)
        runningCoordinator.start()
    }
}
