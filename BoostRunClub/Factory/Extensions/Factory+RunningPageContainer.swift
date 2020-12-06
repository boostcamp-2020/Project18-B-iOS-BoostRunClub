//
//  Factory+RunningPageContainer.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol RunningPageContainerFactory {
    func makeRunningPageVC(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController
    func makeRunningPageVM() -> RunningPageViewModelTypes
}

extension DependencyFactory: RunningPageContainerFactory {
    func makeRunningPageVC(with _: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController {
        let runningPageVC = RunningPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        runningPageVC.setPages(viewControllers)
        return runningPageVC
    }

    func makeRunningPageVM() -> RunningPageViewModelTypes {
        RunningPageViewModel()
    }
}
