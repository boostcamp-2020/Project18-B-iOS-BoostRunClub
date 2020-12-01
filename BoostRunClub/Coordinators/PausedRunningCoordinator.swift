//
//  PausedRunningCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import UIKit

protocol PausedRunningCoordinatorProtocol: Coordinator {
    func showPausedRunningViewController()
}

final class PausedRunningCoordinator: PausedRunningCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()

    private weak var serviceProvider: ServiceProvidable?

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start(serviceProvider: ServiceProvidable? = nil) {
        self.serviceProvider = serviceProvider
        showPausedRunningViewController()
    }

    func showPausedRunningViewController() {
        guard let runningProvider: RunningDataProvider = serviceProvider?.getService() else { return }

        let pausedRunningVM = PausedRunningViewModel(runningProvider: runningProvider)
        pausedRunningVM.showRunningInfoSignal
            .receive(on: RunLoop.main)
            .sink {
                NotificationCenter.default.post(name: .showRunningInfoScene, object: self)
            }
            .store(in: &cancellables)

        let pausedRunningVC = PausedRunningViewController(with: pausedRunningVM)
        navigationController.pushViewController(pausedRunningVC, animated: false)
    }
}
