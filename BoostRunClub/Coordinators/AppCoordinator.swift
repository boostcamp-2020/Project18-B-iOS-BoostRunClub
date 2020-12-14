//
//  AppCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

final class AppCoordinator: BasicCoordinator<Void> {
    override func start() {
        return showMainFlow()
    }

    func showMainFlow() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)

        let uuid = mainTabBarCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: mainTabBarCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case let .running(info):
                    self?.showRunningScene(goalType: info.type, goalValue: info.value)
                }
                self?.release(coordinator: mainTabBarCoordinator)
            }
    }

    func showRunningScene(goalType _: GoalType, goalValue _: String) {
        let runningPageCoordinator = RunningPageCoordinator(navigationController: navigationController)

        let uuid = runningPageCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: runningPageCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .detail:
                    self?.showMainFlow()
                case .prepareRun:
                    self?.showMainFlow()
                }
                self?.release(coordinator: runningPageCoordinator)
            }
    }
}
