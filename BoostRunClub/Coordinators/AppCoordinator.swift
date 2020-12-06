//
//  AppCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

protocol AppCoordinatorProtocol {
    func showLoginFlow()
    func showMainFlow()
    func showRunningScene(goalType: GoalType, goalValue: String)
}

final class AppCoordinator: BasicCoordinator, AppCoordinatorProtocol {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)

        NotificationCenter.default
            .publisher(for: .showRunningScene)
            .sink { [weak self] notification in
                guard
                    let self = self,
                    let goalType = notification.userInfo?["goalType"] as? GoalType,
                    let goalValue = notification.userInfo?["goalValue"] as? String
                else { return }

                self.clear()
                self.showRunningScene(goalType: goalType, goalValue: goalValue)
            }.store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .showPrepareRunningScene)
            .sink { [weak self] _ in
                guard
                    let self = self
                else { return }

                self.clear()
                self.showMainFlow()
            }.store(in: &cancellables)
    }

    override func start() {
        showMainFlow()
    }

    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    func showMainFlow() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }

    func showRunningScene(goalType _: GoalType, goalValue _: String) {
        let runningPageCoordinator = RunningPageCoordinator(navigationController: navigationController)

        childCoordinators.append(runningPageCoordinator)
        runningPageCoordinator.start()
    }
}
