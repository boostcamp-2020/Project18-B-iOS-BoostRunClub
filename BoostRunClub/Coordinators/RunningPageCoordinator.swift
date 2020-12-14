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
    case detail(UUID)
}

final class RunningPageCoordinator: BasicCoordinator<RunningPageCoordinationResult> {
    let factory: RunningPageContainerFactory

    init(
        navigationController: UINavigationController,
        factory: RunningPageContainerFactory = DependencyFactory.shared
    ) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        prepareRunningPageController()
    }

    private func prepareRunningPageController() {
        let mapCoordinator = RunningMapCoordinator(navigationController: UINavigationController())
        let runningCoordinator = RunningCoordinator(navigationController: UINavigationController())
        let splitsCoordinator = SplitsCoordinator(navigationController: UINavigationController())

        coordinate(coordinator: mapCoordinator)
        coordinate(coordinator: splitsCoordinator)
        let closablePublisher = coordinate(coordinator: runningCoordinator)

        let runningPageVM = factory.makeRunningPageVM()
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
                case let .activityDetail(uuid):
                    let result = RunningPageCoordinationResult.detail(uuid)
                    self?.closeSignal.send(result)
                case .prepareRun:
                    let result = RunningPageCoordinationResult.prepareRun
                    self?.closeSignal.send(result)
                }
                self?.release(coordinator: mapCoordinator)
                self?.release(coordinator: runningCoordinator)
                self?.release(coordinator: splitsCoordinator)
            }
    }
}
