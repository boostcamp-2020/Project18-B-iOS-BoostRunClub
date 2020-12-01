//
//  RunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

protocol RunningCoordinatorProtocol: Coordinator {
    func showRunningInfoScene()
    func showPausedRunningScene()
}

final class RunningCoordinator: RunningCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()
    private weak var serviceProvider: ServiceProvidable?

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)

        NotificationCenter.default
            .publisher(for: .showRunningInfoScene)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.showRunningInfoScene()
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

    func start(serviceProvider: ServiceProvidable? = nil) {
        self.serviceProvider = serviceProvider
        showRunningInfoScene()
    }

    func showRunningInfoScene() {
        let runInfoCoordinator = RunningInfoCoordinator(navigationController)
        childCoordinators.append(runInfoCoordinator)
        runInfoCoordinator.start(serviceProvider: serviceProvider)
    }

    func showPausedRunningScene() {
        let pausedRunningCoordinator = PausedRunningCoordinator(navigationController)
        childCoordinators.append(pausedRunningCoordinator)
        pausedRunningCoordinator.start(serviceProvider: serviceProvider)
    }
}
