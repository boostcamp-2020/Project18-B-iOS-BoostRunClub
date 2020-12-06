//
//  Factory+GoalTypeScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol GoalTypeSceneFactory {
//    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController
//    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes
}

extension DependencyFactory: GoalTypeSceneFactory {
    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController {
        GoalTypeViewController(with: viewModel)
    }

    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes {
        GoalTypeViewModel(goalType: goalType)
    }
}
