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
    func makeRunningPageVM() -> RunningPageViewModelTypes
}

extension DependencyFactory: RunningPageContainerFactory {
    func makeRunningPageVC(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController {
        RunningPageViewController(with: viewModel, viewControllers: viewControllers)
    }

    func makeRunningPageVM() -> RunningPageViewModelTypes {
        RunningPageViewModel(runningDataProvider: runningDataProvider)
    }
}
