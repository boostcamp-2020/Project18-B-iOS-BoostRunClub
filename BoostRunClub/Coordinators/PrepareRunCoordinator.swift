//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import UIKit

protocol PrepareRunCoordinatorProtocol: Coordinator {
    func showGoalTypeActionSheet()
    func showGoalSetupViewController()
}

final class PrepareRunCoordinator {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.view.backgroundColor = .systemBackground
    }

    func start() {
        showPrepareRunViewController()
    }

    func showPrepareRunViewController() {
        let prepareRunVC = PrepareRunViewController()
        prepareRunVC.delegate = self
        navigationController.pushViewController(prepareRunVC, animated: true)
    }
}

extension PrepareRunCoordinator: PrepareRunCoordinatorProtocol {
    func showGoalTypeActionSheet() {
        let goalTypeVC = GoalTypeViewController()
        goalTypeVC.modalPresentationStyle = .overFullScreen
        //		navigationController.topViewController!.present(goalTypeVC, animated: true, completion: nil)
        navigationController.present(goalTypeVC, animated: false, completion: nil)
    }

    func showGoalSetupViewController() {}
}
