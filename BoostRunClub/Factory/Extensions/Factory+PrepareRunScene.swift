//
//  Factory+PrepareRunScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController
    func makePrepareRunVM() -> PrepareRunViewModelTypes
}

extension DependencyFactory: PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController {
        PrepareRunViewController(with: viewModel)
    }

    func makePrepareRunVM() -> PrepareRunViewModelTypes {
        PrepareRunViewModel(locationProvider: locationProvider)
    }
}
