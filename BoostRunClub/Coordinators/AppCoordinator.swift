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

    func showActivityDetail(activity: Activity, detail: ActivityDetail) {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        mainTabBarCoordinator.start(activity: activity, detail: detail)

        let uuid = mainTabBarCoordinator.identifier
        closeSubscription[uuid] = mainTabBarCoordinator.closeSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case let .running(info):
                    self?.showRunningScene(goalType: info.type, goalValue: info.value)
                }
                self?.release(coordinator: mainTabBarCoordinator)
            }
    }

    func showRunningScene(goalType: GoalType, goalValue: String) {
        let goalInfo = GoalInfo(type: goalType, value: goalValue)
        let runningPageCoordinator = RunningPageCoordinator(
            navigationController: navigationController,
            goalInfo: goalInfo
        )

        let uuid = runningPageCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: runningPageCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case let .activityDetail(activity, detail):
                    self?.showActivityDetail(activity: activity, detail: detail)
                case .prepareRun:
                    self?.showMainFlow()
                }
                self?.release(coordinator: runningPageCoordinator)
            }
    }
}
