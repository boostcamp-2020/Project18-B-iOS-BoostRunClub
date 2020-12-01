//
//  SplitsViewCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol SplitsCoordinatorProtocol: Coordinator {
    func showSplitsViewController()
}

final class SplitsCoordinator: SplitsCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start(serviceProvider _: ServiceProvidable? = nil) {
        showSplitsViewController()
    }

    func showSplitsViewController() {
        let splitsVC = SplitsViewController()
        navigationController.pushViewController(splitsVC, animated: true)
    }
}
