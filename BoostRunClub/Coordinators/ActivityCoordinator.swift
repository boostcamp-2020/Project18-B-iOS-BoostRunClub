//
//  ActivityCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol ActivityCoordinatorProtocol {}

final class ActivityCoordinator: BasicCoordinator, ActivityCoordinatorProtocol {
    let factory: ActivitySceneFactory

    init(navigationController: UINavigationController, factory: ActivitySceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showActivityViewController()
    }

    func showActivityViewController() {
        let activityVM = factory.makeActivityVM()
        let activityVC = factory.makeActivityVC(with: activityVM)
        navigationController.pushViewController(activityVC, animated: true)
    }
}
