//
//  Factory+PrepareRunScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController
    func makePrepareRunVM() -> PrepareRunViewModelTypes

    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController
    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes

    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController
    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes
}

extension DependencyFactory: PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController {
        PrepareRunViewController(with: viewModel)
    }

    func makePrepareRunVM() -> PrepareRunViewModelTypes {
        PrepareRunViewModel(locationProvider: locationProvider)
    }

    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController {
        GoalTypeViewController(with: viewModel)
    }

    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes {
        GoalTypeViewModel(goalType: goalType)
    }

    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController {
        GoalValueSetupViewController(with: viewModel)
    }

    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes {
        GoalValueSetupViewModel(goalType: goalType, goalValue: goalValue)
    }
}
