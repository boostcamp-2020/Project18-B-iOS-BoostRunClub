//
//  PausedRunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

enum PausedRunCoordinationResult {
    case runInfo, prepareRun, activityDetail(UUID)
}

final class PausedRunningCoordinator: BasicCoordinator<PausedRunCoordinationResult> {
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
                let result = PausedRunCoordinationResult.runInfo
                self?.closeSignal.send(result)
            }
            .store(in: &cancellables)

        pausedRunningVM.outputs.showPrepareRunningSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                // TODO: PrepareRun으로, ActivityDetail로 이동 구분하기
                let result = PausedRunCoordinationResult.prepareRun
                self?.closeSignal.send(result)
            }
            .store(in: &cancellables)

        let pausedRunningVC = factory.makePausedRunningVC(with: pausedRunningVM)
        navigationController.pushViewController(pausedRunningVC, animated: false)
    }
}
