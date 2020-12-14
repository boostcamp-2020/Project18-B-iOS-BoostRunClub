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
}

extension DependencyFactory: ActivityDetailSceneFactory {
    func makeActivityDetailVM(activity: Activity, detail: ActivityDetail?) -> ActivityDetailViewModelTypes? {
        ActivityDetailViewModel(activity: activity, detail: detail, activityProvider: activityProvider)
    }

    func makeActivityDetailVC(with viewModel: ActivityDetailViewModelTypes) -> UIViewController {
        ActivityDetailViewController(with: viewModel)
    }
}
