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
    func showGoalValueSetupViewController(goalInfo: GoalInfo) -> AnyPublisher<String?, Never>
    func showRunningScene(goalInfo: GoalInfo)
}

final class PrepareRunCoordinator: PrepareRunCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.view.backgroundColor = .systemBackground
    }

    func start(serviceProvider _: ServiceProvidable? = nil) {
        showPrepareRunViewController()
    }

    func showPrepareRunViewController() {
        let prepareRunVM = PrepareRunViewModel()

        prepareRunVM.showRunningSceneSignal
            .receive(on: RunLoop.main)
            .sink { self.showRunningScene(goalInfo: $0) }
            .store(in: &cancellables)

        prepareRunVM.showGoalTypeActionSheetSignal
            .receive(on: RunLoop.main)
            .flatMap { self.showGoalTypeActionSheet(goalType: $0) }
            .sink { prepareRunVM.didChangeGoalType($0) }
            .store(in: &cancellables)

        prepareRunVM.showGoalValueSetupSceneSignal
            .receive(on: RunLoop.main)
            .flatMap { self.showGoalValueSetupViewController(goalInfo: $0) }
            .sink { prepareRunVM.didChangeGoalValue($0) }
            .store(in: &cancellables)

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

    func showGoalValueSetupViewController(goalInfo: GoalInfo) -> AnyPublisher<String?, Never> {
        // TODO: goalType, goalValue -> GoalInfo 타입으로 변경
        let goalValueSetupVM = GoalValueSetupViewModel(goalType: goalInfo.goalType, goalValue: goalInfo.goalValue)
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

    func showRunningScene(goalInfo: GoalInfo) {
        // TODO: goalType, goalValue -> GoalInfo 타입으로 변경
        NotificationCenter.default.post(
            name: .showRunningScene,
            object: self,
            userInfo: [
                "goalType": goalInfo.goalType,
                "goalValue": goalInfo.goalValue,
            ]
        )
    }

    deinit {
        print("finished \(self)")
    }
}
