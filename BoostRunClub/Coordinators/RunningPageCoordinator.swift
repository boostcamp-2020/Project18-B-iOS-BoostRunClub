//
//  RunningPageCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

enum RunningPageCoordinationResult {
    case prepareRun
    case activityDetail(activity: Activity, detail: ActivityDetail)
}

final class RunningPageCoordinator: BasicCoordinator<RunningPageCoordinationResult> {
    let factory: RunningPageContainerFactory
    let goalInfo: GoalInfo
    init(
        navigationController: UINavigationController,
        factory: RunningPageContainerFactory = DependencyFactory.shared,
        goalInfo: GoalInfo
    ) {
        self.factory = factory
        self.goalInfo = goalInfo
        super.init(navigationController: navigationController)
    }

    override func start() {
        prepareRunningPageController()
    }

    private func prepareRunningPageController() {
        let mapCoordinator = RunningMapCoordinator(navigationController: UINavigationController())
        let runningCoordinator = RunningCoordinator(navigationController: UINavigationController())
        let splitsCoordinator = SplitsCoordinator(navigationController: UINavigationController())

        let closablePublisherWithoutRelease = coordinate(coordinator: mapCoordinator)
        coordinate(coordinator: splitsCoordinator)
        let closablePublisher = coordinate(coordinator: runningCoordinator)

        let runningPageVM = factory.makeRunningPageVM(goalInfo: goalInfo)
        let runningPageVC = factory.makeRunningPageVC(
            with: runningPageVM,
            viewControllers: [
                mapCoordinator.navigationController,
                runningCoordinator.navigationController,
                splitsCoordinator.navigationController,
            ]
        )

        navigationController.viewControllers = [runningPageVC]

        let uuid = runningCoordinator.identifier
        closeSubscription[uuid] = closablePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case let .activityDetail(activity, detail):
                    let result = RunningPageCoordinationResult.activityDetail(activity: activity, detail: detail)
                    self?.closeSignal.send(result)
                case .prepareRun:
                    let result = RunningPageCoordinationResult.prepareRun
                    self?.closeSignal.send(result)
                }
                self?.release(coordinator: mapCoordinator)
                self?.release(coordinator: runningCoordinator)
                self?.release(coordinator: splitsCoordinator)
            }

        closeSubscription[mapCoordinator.identifier] = closablePublisherWithoutRelease
            .sink { runningPageVM.inputs.didTapGoBackButton() }
    }
}
