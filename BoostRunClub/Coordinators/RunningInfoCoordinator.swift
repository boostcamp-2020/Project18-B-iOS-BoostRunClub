//
//  RunningInfoCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

enum RunningInfoCoordinationResult {
    case pausedRun
}

final class RunningInfoCoordinator: BasicCoordinator<RunningInfoCoordinationResult> {
    let factory: RunningInfoSceneFactory
    var isResumed: Bool
    init(navigationController: UINavigationController, isResume: Bool, factory: RunningInfoSceneFactory = DependencyFactory.shared) {
        isResumed = isResume
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showRunningInfoViewController()
    }

    func showRunningInfoViewController() {
        let runningInfoVM = factory.makeRunningInfoVM(isResumed: isResumed)

        runningInfoVM.outputs.showPausedRunningSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let result = RunningInfoCoordinationResult.pausedRun
                self?.closeSignal.send(result)
                self?.navigationController.popViewController(animated: false)
            }
            .store(in: &cancellables)

        let runningInfoVC = factory.makeRunningInfoVC(with: runningInfoVM)
        navigationController.pushViewController(runningInfoVC, animated: false)
    }
}
