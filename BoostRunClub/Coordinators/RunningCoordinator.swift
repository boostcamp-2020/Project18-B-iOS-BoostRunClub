//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

protocol RunningCoordinatorProtocol {
    func showRunningInfoScene()
    func showPausedRunningScene()
}

final class RunningCoordinator: BasicCoordinator, RunningCoordinatorProtocol {
    required init(navigationController: UINavigationController, factory: Factory) {
        super.init(navigationController: navigationController, factory: factory)

        NotificationCenter.default
            .publisher(for: .showRunningInfoScene)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showRunningInfoScene()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .showPausedRunningScene)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showPausedRunningScene()
            }
            .store(in: &cancellables)
    }

    override func start() {
        showRunningInfoScene()
    }

    func showRunningInfoScene() {
        let runInfoCoordinator = RunningInfoCoordinator(navigationController: navigationController, factory: factory)
        childCoordinators.append(runInfoCoordinator)
        runInfoCoordinator.start()
    }

    func showPausedRunningScene() {
        let pausedRunningCoordinator = PausedRunningCoordinator(navigationController: navigationController, factory: factory)
        childCoordinators.append(pausedRunningCoordinator)
        pausedRunningCoordinator.start()
    }
}
