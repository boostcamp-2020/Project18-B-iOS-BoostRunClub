//
//  TabBarCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

enum TabBarPage: Int {
    case activity
    case running
    case profile

    // TODO:
    // Add tab icon value
    // Add tab icon selected / deselected color
}

protocol MainTabBarCoordinatorProtocol {}

final class MainTabBarCoordinator: BasicCoordinator, MainTabBarCoordinatorProtocol {
    let factory: TabBarContainerFactory

    init(navigationController: UINavigationController, factory: TabBarContainerFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        prepareTabBarController()
    }

    private func prepareTabBarController() {
        childCoordinators = [
            ActivityCoordinator(navigationController: UINavigationController()),
            PrepareRunCoordinator(navigationController: UINavigationController()),
            ProfileCoordinator(navigationController: UINavigationController()),
        ]

        childCoordinators.forEach { $0.start() }

        let tabBarController = factory.makeTabBarVC(
            with: childCoordinators.map { $0.navigationController },
            selectedIndex: TabBarPage.running.rawValue
        )
        navigationController.viewControllers = [tabBarController]
    }
}
