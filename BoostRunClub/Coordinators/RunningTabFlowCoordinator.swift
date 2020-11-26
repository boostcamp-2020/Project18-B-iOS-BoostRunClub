//
//  RunningTabFlowCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol RunningTabFlowCoordinatorProtocol: Coordinator {
    func showPrepareRunFlow()
}

final class RunningTabFlowCoordinator: RunningTabFlowCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.view.backgroundColor = .systemBackground
    }

    func start() {
        showPrepareRunFlow()
    }

    func showPrepareRunFlow() {
        let prepareRunCoordinator = PrepareRunCoordinator(navigationController)
        childCoordinators.append(prepareRunCoordinator)
        prepareRunCoordinator.start()
    }

    deinit {
        print("finished \(self)")
    }
}
