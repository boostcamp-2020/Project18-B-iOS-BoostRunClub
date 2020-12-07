//
//  PausedRunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

protocol PausedRunningCoordinatorProtocol {
    func showPausedRunningViewController()
}

final class PausedRunningCoordinator: BasicCoordinator, PausedRunningCoordinatorProtocol {
    let factory: PausedRunningSceneFactory

    init(navigationController: UINavigationController, factory: PausedRunningSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showPausedRunningViewController()
    }

    func showPausedRunningViewController() {
        let pausedRunningVM = factory.makePausedRunningVM()
        pausedRunningVM.outputs.showRunningInfoSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                NotificationCenter.default.post(name: .showRunningInfoScene, object: self)
            }
            .store(in: &cancellables)
        pausedRunningVM.outputs.showPrepareRunningSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                NotificationCenter.default.post(name: .showPrepareRunningScene, object: self)
            }
            .store(in: &cancellables)
        let pausedRunningVC = factory.makePausedRunningVC(with: pausedRunningVM)
        navigationController.pushViewController(pausedRunningVC, animated: false)
    }
}
