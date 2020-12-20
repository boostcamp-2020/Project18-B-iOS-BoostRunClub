//
//  RunningMapCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

final class RunningMapCoordinator: BasicCoordinator<Void> {
    let factory: RunningMapSceneFactory

    init(navigationController: UINavigationController, factory: RunningMapSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showRunningMapViewController()
    }

    func showRunningMapViewController() {
        let runningMapVM = factory.makeRunningMapVM()
        runningMapVM.outputs.closeSignal
            .sink { [weak self] in self?.closeSignal.send() }
            .store(in: &cancellables)

        let runningMapVC = factory.makeRunningMapVC(with: runningMapVM)
        navigationController.pushViewController(runningMapVC, animated: true)
    }
}
