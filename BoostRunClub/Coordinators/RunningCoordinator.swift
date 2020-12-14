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
    case activityDetail(UUID)
}

final class RunningCoordinator: BasicCoordinator<RunningCoordinationResult> {
    override func start() {
        showRunningInfoScene()
    }

    func showRunningInfoScene() {
        let runInfoCoordinator = RunningInfoCoordinator(navigationController: navigationController)

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
                    self?.showRunningInfoScene()
                case .prepareRun:
                    let result = RunningCoordinationResult.prepareRun
                    self?.closeSignal.send(result)
                case let .activityDetail(uuid):
                    let result = RunningCoordinationResult.activityDetail(uuid)
                    self?.closeSignal.send(result)
                }

                self?.release(coordinator: pausedRunningCoordinator)
            }
    }
}
