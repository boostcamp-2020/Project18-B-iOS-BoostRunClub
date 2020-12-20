//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

enum RunningCoordinationResult {
    case prepareRun
    case activityDetail(activity: Activity, detail: ActivityDetail)
}

final class RunningCoordinator: BasicCoordinator<RunningCoordinationResult> {
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        navigationController.pushViewController(UIViewController(), animated: false)
    }

    override func start() {
        showRunningInfoScene(isResume: false)
    }

    func showRunningInfoScene(isResume: Bool) {
        let runInfoCoordinator = RunningInfoCoordinator(navigationController: navigationController, isResume: isResume)

        let uuid = runInfoCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: runInfoCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .pausedRun:
                    self?.showPausedRunningScene()
                }
                self?.release(coordinator: runInfoCoordinator)
            }
    }

    func showPausedRunningScene() {
        let pausedRunningCoordinator = PausedRunningCoordinator(navigationController: navigationController)

        let uuid = pausedRunningCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: pausedRunningCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case .runInfo:
                    self?.showRunningInfoScene(isResume: true)
                case .prepareRun:
                    let result = RunningCoordinationResult.prepareRun
                    self?.closeSignal.send(result)
                case let .activityDetail(activity, detail):
                    let result = RunningCoordinationResult.activityDetail(activity: activity, detail: detail)
                    self?.closeSignal.send(result)
                }
                self?.release(coordinator: pausedRunningCoordinator)
            }
    }
}
