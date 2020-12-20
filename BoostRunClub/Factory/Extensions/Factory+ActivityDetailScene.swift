//
//  Factory+ActivityDetailScene.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

protocol ActivityDetailSceneFactory {
    func makeActivityDetailVM(activity: Activity, detail: ActivityDetail?) -> ActivityDetailViewModelTypes?
    func makeActivityDetailVC(with: ActivityDetailViewModelTypes) -> UIViewController

    func makeSplitInfoDetailVM(activity: Activity) -> SplitInfoDetailViewModelType?
    func makeSplitInfoDetailVC(with viewModel: SplitInfoDetailViewModelType) -> UIViewController
}

extension DependencyFactory: ActivityDetailSceneFactory {
    func makeActivityDetailVM(activity: Activity, detail: ActivityDetail?) -> ActivityDetailViewModelTypes? {
        ActivityDetailViewModel(activity: activity, detail: detail, activityService: activityStorageService)
    }

    func makeActivityDetailVC(with viewModel: ActivityDetailViewModelTypes) -> UIViewController {
        ActivityDetailViewController(with: viewModel)
    }

    func makeSplitInfoDetailVM(activity: Activity) -> SplitInfoDetailViewModelType? {
        SplitInfoDetailViewModel(activity: activity, activityReader: activityStorageService)
    }

    func makeSplitInfoDetailVC(with viewModel: SplitInfoDetailViewModelType) -> UIViewController {
        SplitInfoDetailViewController(with: viewModel)
    }
}
