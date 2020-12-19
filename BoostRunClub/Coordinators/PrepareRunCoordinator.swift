//
//  PrepareRunCoordinator.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

enum PrepareRunCoordinationResult {
    case run(GoalInfo), profile
}

final class PrepareRunCoordinator: BasicCoordinator<PrepareRunCoordinationResult> {
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
            .sink { [weak self] in
                let result = PrepareRunCoordinationResult.run($0)
                self?.closeSignal.send(result)
            }
            .store(in: &cancellables)

        prepareRunVM.outputs.showGoalTypeActionSheetSignal
            .receive(on: RunLoop.main)
            .compactMap { [weak self] in self?.showGoalTypeActionSheet(goalType: $0) }
            .flatMap { $0 }
            .sink { prepareRunVM.inputs.didChangeGoalType($0) }
            .store(in: &cancellables)

        prepareRunVM.outputs.showGoalValueSetupSceneSignal
            .receive(on: RunLoop.main)
            .compactMap { [weak self] in self?.showGoalValueSetupViewController(goalInfo: $0) }
            .flatMap { $0 }
            .sink { prepareRunVM.inputs.didChangeGoalValue($0) }
            .store(in: &cancellables)

        prepareRunVM.outputs.showProfileSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let result = PrepareRunCoordinationResult.profile
                self?.closeSignal.send(result)
            }
            .store(in: &cancellables)

        let prepareRunVC = factory.makePrepareRunVC(with: prepareRunVM)
        navigationController.pushViewController(prepareRunVC, animated: true)
    }

    func showGoalTypeActionSheet(goalType: GoalType = .none) -> AnyPublisher<GoalType, Never> {
        let goalTypeVM = factory.makeGoalTypeVM(goalType: goalType)
        let goalTypeVC = factory.makeGoalTypeVC(with: goalTypeVM)

        goalTypeVC.modalPresentationStyle = .overFullScreen
        navigationController.present(goalTypeVC, animated: false, completion: nil)

        return goalTypeVM.outputs.closeSignal.eraseToAnyPublisher()
    }

    func showGoalValueSetupViewController(goalInfo: GoalInfo) -> AnyPublisher<String?, Never> {
        let goalValueSetupVM = factory.makeGoalValueSetupVM(
            goalType: goalInfo.type,
            goalValue: goalInfo.value
        )

        let goalValueSetupVC = factory.makeGoalValueSetupVC(with: goalValueSetupVM)
        navigationController.pushViewController(goalValueSetupVC, animated: false)

        return goalValueSetupVM.outputs.closeSignal
            .receive(on: RunLoop.main)
            .map { [weak goalValueSetupVC] in
                goalValueSetupVC?.navigationController?.popViewController(animated: false)
                return $0
            }
            .eraseToAnyPublisher()
    }
}
