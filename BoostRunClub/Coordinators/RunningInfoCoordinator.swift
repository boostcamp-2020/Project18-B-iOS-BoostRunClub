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

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showRunningInfoViewController()
    }

    func showRunningInfoViewController() {
        let runningInfoVM = RunningInfoViewModel(goalType: .none, goalValue: "")
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
