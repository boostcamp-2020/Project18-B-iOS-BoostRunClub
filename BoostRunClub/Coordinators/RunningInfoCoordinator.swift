//
//  RunningInfoCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

protocol RunningInfoCoordinatorProtocol {
    func showRunningInfoViewController()
}

final class RunningInfoCoordinator: BasicCoordinator, RunningInfoCoordinatorProtocol {
    override func start() {
        showRunningInfoViewController()
    }

    func showRunningInfoViewController() {
        let runningInfoVM = factory.makeRunningInfoVM()

        runningInfoVM.outputs.showPausedRunningSignal
            .receive(on: RunLoop.main)
            .sink {
                NotificationCenter.default.post(name: .showPausedRunningScene, object: self)
            }
            .store(in: &cancellables)

        let runningInfoVC = factory.makeRunningInfoVC(with: runningInfoVM)
        navigationController.pushViewController(runningInfoVC, animated: false)
    }
}
