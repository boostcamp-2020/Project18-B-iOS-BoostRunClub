//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

protocol PrepareRunCoordinatorProtocol: Coordinator {
    func showGoalTypeActionSheet(goalType: GoalType)
    func showGoalSetupViewController()
    func showRunningScene(_ goalType: GoalType)
}

final class PrepareRunCoordinator: PrepareRunCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?

    var type: CoordinatorType { .prepareRun }

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

    func showGoalTypeActionSheet(goalType: GoalType = .none) {
        let goalTypeVM = GoalTypeViewModel(goalType: goalType)
        let goalTypeVC = GoalTypeViewController(with: goalTypeVM)
        goalTypeVC.delegate = navigationController.topViewController as? PrepareRunViewController
        goalTypeVC.modalPresentationStyle = .overFullScreen
        navigationController.present(goalTypeVC, animated: false, completion: nil)
    }

    func showGoalSetupViewController() {}
    func showRunningScene(_: GoalType) {
        NotificationCenter.default.post(name: .showRunningScene, object: self)
    }

    deinit {
        print("finished \(self)")
    }
}
