//
//  Factory+ActivityScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol ActivitySceneFactory {
    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController
    func makeActivityVM() -> ActivityViewModelTypes

    func makeActivityDateFilterVC(with viewModel: ActivityDateFilterViewModelTypes, tabHeight: CGFloat) -> UIViewController
    func makeActivityDateFilterVM(filterType: ActivityFilterType, dateRanges: [DateRange]) -> ActivityDateFilterViewModelTypes
}

extension DependencyFactory: ActivitySceneFactory {
    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController {
        return ActivityViewController(with: viewModel)
    }

    func makeActivityVM() -> ActivityViewModelTypes {
        return ActivityViewModel(activityProvider: activityProvider)
    }

    func makeActivityDateFilterVC(with viewModel: ActivityDateFilterViewModelTypes, tabHeight: CGFloat) -> UIViewController {
        let vc = ActivityDateFilterViewController(with: viewModel)
        vc.tabHeight = tabHeight
        return vc
    }

    func makeActivityDateFilterVM(filterType: ActivityFilterType, dateRanges: [DateRange]) -> ActivityDateFilterViewModelTypes {
        return ActivityDateFilterViewModel(filterType: filterType, dateRanges: dateRanges)
    }
}
