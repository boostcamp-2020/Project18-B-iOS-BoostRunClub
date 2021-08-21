//
//  Factory+SplitScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol SplitSceneFactory {
    func makeSplitVC(with viewModel: SplitsViewModelTypes) -> UIViewController
    func makeSplitVM() -> SplitsViewModelTypes
    func makeRunningSplitCellVM() -> RunningSplitCellViewModelType
}

extension DependencyFactory: SplitSceneFactory {
    func makeRunningSplitCellVM() -> RunningSplitCellViewModelType {
        RunningSplitCellViewModel()
    }

    func makeSplitVC(with viewModel: SplitsViewModelTypes) -> UIViewController {
        SplitsViewController(with: viewModel)
    }

    func makeSplitVM() -> SplitsViewModelTypes {
        SplitsViewModel(runningService: runningDataService)
    }
}
