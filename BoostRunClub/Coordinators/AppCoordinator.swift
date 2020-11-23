//
//  AppCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
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
}
