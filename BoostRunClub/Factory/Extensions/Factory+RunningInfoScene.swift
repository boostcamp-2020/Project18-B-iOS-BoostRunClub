//
//  Factory+RunningInfoScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController
    func makeRunningInfoVM(isResumed: Bool) -> RunningInfoViewModelTypes
}

extension DependencyFactory: RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController {
        RunningInfoViewController(with: viewModel)
    }

    func makeRunningInfoVM(isResumed: Bool) -> RunningInfoViewModelTypes {
        RunningInfoViewModel(runningService: runningDataService, resumed: isResumed)
    }
}
