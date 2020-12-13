//
//  Factory+ActivityDetailScene.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

protocol ActivityDetailSceneFactory {
    func makeActivityDetailVM(activity: Activity) -> ActivityDetailViewModelTypes?
    func makeActivityDetailVC(with: ActivityDetailViewModelTypes) -> UIViewController

    func makeSplitInfoDetailVM()
    func makeSplitInfoDetailVC() -> UIViewController
}

extension DependencyFactory: ActivityDetailSceneFactory {
    func makeActivityDetailVM(activity: Activity) -> ActivityDetailViewModelTypes? {
        ActivityDetailViewModel(activity: activity, activityProvider: activityProvider)
    }

    func makeActivityDetailVC(with viewModel: ActivityDetailViewModelTypes) -> UIViewController {
        ActivityDetailViewController(with: viewModel)
    }

    func makeSplitInfoDetailVM() {}

    func makeSplitInfoDetailVC() -> UIViewController {
        SplitInfoDetailViewController()
    }
}
