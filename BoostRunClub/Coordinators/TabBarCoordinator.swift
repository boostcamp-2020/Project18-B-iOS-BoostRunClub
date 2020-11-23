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

protocol MainTabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
}

final class MainTabBarCoordinator: NSObject, MainTabBarCoordinatorProtocol {
    var tabBarController = UITabBarController()

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        prepareTabBarController()
    }

    private func prepareTabBarController() {
        childCoordinators = [
            ActivityCoordinator(UINavigationController()),
            RunningCoordinator(UINavigationController()),
            ProfileCoordinator(UINavigationController()),
        ]

        childCoordinators.forEach { $0.start() }

        tabBarController.setViewControllers(childCoordinators.map { $0.navigationController }, animated: true)
        tabBarController.selectedIndex = TabBarPage.running.rawValue
        tabBarController.tabBar.isTranslucent = false

        navigationController.viewControllers = [tabBarController]
    }
}
