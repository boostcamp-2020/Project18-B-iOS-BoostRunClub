//
//  Factory+RunningPageContainer.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol RunningPageContainerFactory {
    func makeRunningPageVC(
        with viewModel: RunningPageViewModelTypes,
        viewControllers: [UIViewController]
    )
        -> UIViewController
    func makeRunningPageVM(goalInfo: GoalInfo?) -> RunningPageViewModelTypes
}

extension DependencyFactory: RunningPageContainerFactory {
    func makeRunningPageVC(
        with viewModel: RunningPageViewModelTypes,
        viewControllers: [UIViewController]
    ) -> UIViewController {
        RunningPageViewController(with: viewModel, viewControllers: viewControllers)
    }

    func makeRunningPageVM(goalInfo: GoalInfo? = nil) -> RunningPageViewModelTypes {
        runningDataService.setGoal(goalInfo)
        return RunningPageViewModel(runningService: runningDataService)
    }
}
