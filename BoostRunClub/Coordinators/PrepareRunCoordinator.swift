//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import UIKit

protocol PrepareRunCoordinatorProtocol: Coordinator {
    func showGoalTypeActionSheet(completion: (Int) -> Void)
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
        let prepareRunViewModel = PrepareRunViewModel()
        prepareRunViewModel.coordinator = self
        let prepareRunVC = PrepareRunViewController()
        prepareRunVC.viewModel = prepareRunViewModel
        navigationController.pushViewController(prepareRunVC, animated: true)
    }
}

extension PrepareRunCoordinator: PrepareRunCoordinatorProtocol {
    // TODO: Int to GoalType
    func showGoalTypeActionSheet(completion _: (Int) -> Void) {
        let goalTypeVC = GoalTypeViewController()
        goalTypeVC.modalPresentationStyle = .overFullScreen
        navigationController.present(goalTypeVC, animated: false, completion: nil)
    }

    func showGoalSetupViewController() {}
}
