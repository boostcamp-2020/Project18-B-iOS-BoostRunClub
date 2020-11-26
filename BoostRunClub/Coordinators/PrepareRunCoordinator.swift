//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

protocol PrepareRunCoordinatorProtocol: Coordinator {
    func showGoalTypeActionSheet(goalType: GoalType) -> AnyPublisher<GoalType, Never>
    func showGoalValueSetupViewController(goalType: GoalType, goalValue: String) -> AnyPublisher<String?, Never>
    func showRunningScene(_ goalType: GoalType)
}

final class PrepareRunCoordinator: PrepareRunCoordinatorProtocol {
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
        let prepareRunVM = PrepareRunViewModel()
        prepareRunVM.coordinator = self
        let prepareRunVC = PrepareRunViewController(with: prepareRunVM)
        navigationController.pushViewController(prepareRunVC, animated: true)
    }

    func showGoalTypeActionSheet(goalType: GoalType = .none) -> AnyPublisher<GoalType, Never> {
        let goalTypeVM = GoalTypeViewModel(goalType: goalType)
        let goalTypeVC = GoalTypeViewController(with: goalTypeVM)
        goalTypeVC.modalPresentationStyle = .overFullScreen
        navigationController.present(goalTypeVC, animated: false, completion: nil)

        return goalTypeVM.closeSheetSignal.receive(on: RunLoop.main)
            .map {
                goalTypeVC.closeWithAnimation()
                return $0
            }.eraseToAnyPublisher()
    }

    func showGoalValueSetupViewController(goalType: GoalType, goalValue: String) -> AnyPublisher<String?, Never> {
        let goalValueSetupVM = GoalValueSetupViewModel(goalType: goalType, goalValue: goalValue)
        let goalValueSetupVC = GoalValueSetupViewController(with: goalValueSetupVM)
        navigationController.pushViewController(goalValueSetupVC, animated: false)

        return goalValueSetupVM.closeSheetSignal
            .receive(on: RunLoop.main)
            .map {
                goalValueSetupVC.navigationController?.popViewController(animated: false)
                return $0
            }
            .eraseToAnyPublisher()
    }

    func showRunningScene(_: GoalType) {
        NotificationCenter.default.post(name: .showRunningScene, object: self)
    }

    deinit {
        print("finished \(self)")
    }
}
