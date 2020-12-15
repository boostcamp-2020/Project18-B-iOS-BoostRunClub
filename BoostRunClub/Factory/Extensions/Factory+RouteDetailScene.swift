//
//  Factory+RouteDetailScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/13.
//

import UIKit

protocol RouteDetailSceneFactory {
    func makeRouteDetailVC(with viewModel: RouteDetailViewModelTypes) -> UIViewController
    func makeRouteDetailVM(activityDetailConfig: ActivityDetailConfig) -> RouteDetailViewModelTypes
}

extension DependencyFactory: RouteDetailSceneFactory {
    func makeRouteDetailVC(with viewModel: RouteDetailViewModelTypes) -> UIViewController {
        RouteDetailViewController(with: viewModel)
    }

    func makeRouteDetailVM(activityDetailConfig: ActivityDetailConfig) -> RouteDetailViewModelTypes {
        RouteDetailViewModel(activityDetailConfig: activityDetailConfig)
    }
}
