//
//  Factory+PausedRunningScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol PausedRunningSceneFactory {
    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController
    func makePausedRunningVM() -> PausedRunningViewModelTypes
}

extension DependencyFactory: PausedRunningSceneFactory {
    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController {
        PausedRunningViewController(with: viewModel)
    }

    func makePausedRunningVM() -> PausedRunningViewModelTypes {
        PausedRunningViewModel(runningService: runningDataService)
    }
}
