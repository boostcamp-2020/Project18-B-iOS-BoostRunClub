//
//  Factory+AllActivitiesScene.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

protocol ActivityListSceneFactory {
    func makeActivityListVC(with viewModel: ActivityListViewModelTypes) -> UIViewController
    func makeActivityListVM() -> ActivityListViewModelTypes
}

extension DependencyFactory: ActivityListSceneFactory {
    func makeActivityListVC(with viewModel: ActivityListViewModelTypes) -> UIViewController {
        ActivityListViewController(with: viewModel)
    }

    func makeActivityListVM() -> ActivityListViewModelTypes {
        ActivityListViewModel(activityReader: activityStorageService)
    }
}
