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
    override func start() {
        showPausedRunningViewController()
    }

    func showPausedRunningViewController() {
        let pausedRunningVM = factory.makePausedRunningVM()
        pausedRunningVM.outputs.showRunningInfoSignal
            .receive(on: RunLoop.main)
            .sink {
                NotificationCenter.default.post(name: .showRunningInfoScene, object: self)
            }
            .store(in: &cancellables)
        pausedRunningVM.outputs.showPrepareRunningSignal
            .receive(on: RunLoop.main)
            .sink {
                NotificationCenter.default.post(name: .showPrepareRunningScene, object: self)
            }
            .store(in: &cancellables)
        let pausedRunningVC = factory.makePausedRunningVC(with: pausedRunningVM)
        navigationController.pushViewController(pausedRunningVC, animated: false)
    }
}
