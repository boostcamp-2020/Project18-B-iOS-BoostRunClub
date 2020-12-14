//
//  RunningInfoCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

protocol RunningInfoCoordinatorProtocol {
    func showRunningInfoViewController(resume: Bool)
}

final class RunningInfoCoordinator: BasicCoordinator, RunningInfoCoordinatorProtocol {
    let factory: RunningInfoSceneFactory

    init(navigationController: UINavigationController, factory: RunningInfoSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showRunningInfoViewController(resume: false)
    }

    func resumeRunning() {
        showRunningInfoViewController(resume: true)
    }

    func showRunningInfoViewController(resume: Bool = false) {
        let runningInfoVM = factory.makeRunningInfoVM()

        runningInfoVM.outputs.showPausedRunningSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                NotificationCenter.default.post(name: .showPausedRunningScene, object: self)
            }
            .store(in: &cancellables)

        let runningInfoVC = factory.makeRunningInfoVC(with: runningInfoVM, resume: resume)
        navigationController.pushViewController(runningInfoVC, animated: false)
    }
}
