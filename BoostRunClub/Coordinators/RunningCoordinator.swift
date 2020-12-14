//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

protocol RunningCoordinatorProtocol {
    func showRunningInfoScene(resume: Bool)
    func showPausedRunningScene()
}

final class RunningCoordinator: BasicCoordinator, RunningCoordinatorProtocol {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)

        NotificationCenter.default
            .publisher(for: .showRunningInfoScene)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showRunningInfoScene(resume: true)
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
        showRunningInfoScene(resume: false)
    }

    func showRunningInfoScene(resume: Bool) {
        clear()
        let runInfoCoordinator = RunningInfoCoordinator(navigationController: navigationController)
        childCoordinators.append(runInfoCoordinator)
        resume ? runInfoCoordinator.resumeRunning() : runInfoCoordinator.start()
    }

    func showPausedRunningScene() {
        clear()
        let pausedRunningCoordinator = PausedRunningCoordinator(navigationController: navigationController)
        childCoordinators.append(pausedRunningCoordinator)
        pausedRunningCoordinator.start()
    }
}
