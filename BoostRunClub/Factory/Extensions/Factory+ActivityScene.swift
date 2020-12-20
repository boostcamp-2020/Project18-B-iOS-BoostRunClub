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

    func makeActivityDateFilterVC(
        with viewModel: ActivityDateFilterViewModelTypes,
        tabHeight: CGFloat
    ) -> UIViewController

    func makeActivityDateFilterVM(
        filterType: ActivityFilterType,
        dateRanges: [DateRange],
        currentRange: DateRange
    ) -> ActivityDateFilterViewModelTypes
}

extension DependencyFactory: ActivitySceneFactory {
    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController {
        return ActivityViewController(with: viewModel)
    }

    func makeActivityVM() -> ActivityViewModelTypes {
        return ActivityViewModel(activityReader: activityStorageService)
    }

    func makeActivityDateFilterVC(
        with viewModel: ActivityDateFilterViewModelTypes,
        tabHeight: CGFloat
    ) -> UIViewController {
        return ActivityDateFilterViewController(with: viewModel, tabHeight: tabHeight)
    }

    func makeActivityDateFilterVM(
        filterType: ActivityFilterType,
        dateRanges: [DateRange],
        currentRange: DateRange
    ) -> ActivityDateFilterViewModelTypes {
        return ActivityDateFilterViewModel(
            filterType: filterType,
            dateRanges: dateRanges,
            currentRange: currentRange
        )
    }
}
