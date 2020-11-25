//
//  ActivityCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol ActivityCoordinatorProtocol: Coordinator {}

final class ActivityCoordinator: ActivityCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?

    var type: CoordinatorType { .activity }

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showActivityViewController()
    }

    func showActivityViewController() {
        let activityVC = ActivityViewController()
        navigationController.pushViewController(activityVC, animated: true)
    }
}
