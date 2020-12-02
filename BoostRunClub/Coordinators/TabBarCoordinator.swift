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

    // Add tab icon value

    // Add tab icon selected / deselected color
}

protocol MainTabBarCoordinatorProtocol {}

final class MainTabBarCoordinator: BasicCoordinator, MainTabBarCoordinatorProtocol {
    override func start() {
        prepareTabBarController()
    }

    private func prepareTabBarController() {
        childCoordinators = [
            ActivityCoordinator(navigationController: UINavigationController(), factory: factory),
            PrepareRunCoordinator(navigationController: UINavigationController(), factory: factory),
            ProfileCoordinator(navigationController: UINavigationController(), factory: factory),
        ]

        childCoordinators.forEach { $0.start() }

        let tabBarController = factory.makeTabBarVC(with: childCoordinators.map { $0.navigationController }, selectedIndex: TabBarPage.running.rawValue)
        navigationController.viewControllers = [tabBarController]
    }

    deinit {
        print("finished \(self)")
    }
}
