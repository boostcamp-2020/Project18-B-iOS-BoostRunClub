//
//  Factory+GoalValueSetupScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol GoalValueSetupSceneFactory {
    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController
    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes
}

extension DependencyFactory: GoalValueSetupSceneFactory {
    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController {
        GoalValueSetupViewController(with: viewModel)
    }

    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes {
        GoalValueSetupViewModel(goalType: goalType, goalValue: goalValue)
    }
}
