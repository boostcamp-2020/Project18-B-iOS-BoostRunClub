//
//  RunningInfoCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

protocol RunningInfoCoordinatorProtocol: Coordinator {
    func showRunningInfoViewController()
}

final class RunningInfoCoordinator: RunningInfoCoordinatorProtocol {
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
        showRunningInfoViewController()
    }

    func showRunningInfoViewController() {
        guard let runningProvider: RunningDataProvider = serviceProvider?.getService() else { return }

        let runningInfoVM = RunningInfoViewModel(runningProvider: runningProvider)
        runningInfoVM.showPausedRunningSignal
            .receive(on: RunLoop.main)
            .sink {
                NotificationCenter.default.post(name: .showPausedRunningScene, object: self)
            }
            .store(in: &cancellables)

        let runningInfoVC = RunningInfoViewController(with: runningInfoVM)
        navigationController.pushViewController(runningInfoVC, animated: false)
    }
}
