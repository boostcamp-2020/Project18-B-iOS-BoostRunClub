//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

protocol PrepareRunCoordinatorProtocol {
    func showGoalTypeActionSheet(goalType: GoalType) -> AnyPublisher<GoalType, Never>
    func showGoalValueSetupViewController(goalInfo: GoalInfo) -> AnyPublisher<String?, Never>
    func showRunningScene(goalInfo: GoalInfo)
}

final class PrepareRunCoordinator: BasicCoordinator, PrepareRunCoordinatorProtocol {
    let factory: PrepareRunSceneFactory

    init(navigationController: UINavigationController, factory: PrepareRunSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    override func start() {
        showPrepareRunViewController()
    }

    func showPrepareRunViewController() {
        let prepareRunVM = factory.makePrepareRunVM()

        prepareRunVM.outputs.showRunningSceneSignal
            .receive(on: RunLoop.main)
            .sink { [unowned self] in self.showRunningScene(goalInfo: $0) }
            .store(in: &cancellables)

        prepareRunVM.outputs.showGoalTypeActionSheetSignal
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] in self.showGoalTypeActionSheet(goalType: $0) }
            .sink { prepareRunVM.inputs.didChangeGoalType($0) }
            .store(in: &cancellables)

        prepareRunVM.outputs.showGoalValueSetupSceneSignal
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] in self.showGoalValueSetupViewController(goalInfo: $0) }
            .sink { prepareRunVM.inputs.didChangeGoalValue($0) }
            .store(in: &cancellables)

        let prepareRunVC = factory.makePrepareRunVC(with: prepareRunVM)
        navigationController.pushViewController(prepareRunVC, animated: true)
    }

    func showGoalTypeActionSheet(goalType: GoalType = .none) -> AnyPublisher<GoalType, Never> {
        let goalTypeVM = GoalTypeViewModel(goalType: goalType)
        let goalTypeVC = GoalTypeViewController(with: goalTypeVM)

        goalTypeVC.modalPresentationStyle = .overFullScreen
        navigationController.present(goalTypeVC, animated: false, completion: nil)

        return goalTypeVM.closeSheetSignal.receive(on: RunLoop.main)
            .map { [unowned goalTypeVC] in
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
            .map { [unowned goalValueSetupVC] in
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
        print("[\(Date())] 🌈Coordinator🌈 \(Self.self) deallocated.")
    }
}
