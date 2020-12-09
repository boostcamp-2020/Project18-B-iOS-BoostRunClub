//
//  SplitsViewCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol SplitsCoordinatorProtocol {
    func showSplitsViewController()
}

final class SplitsCoordinator: BasicCoordinator, SplitsCoordinatorProtocol {
    let factory: SplitSceneFactory

    init(navigationController: UINavigationController, factory: SplitSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    override func start() {
        showSplitsViewController()
    }

    func showSplitsViewController() {
        let splitsVM = factory.makeSplitVM()
        let splitsVC = factory.makeSplitVC(with: splitsVM)
        navigationController.pushViewController(splitsVC, animated: true)
    }
}
