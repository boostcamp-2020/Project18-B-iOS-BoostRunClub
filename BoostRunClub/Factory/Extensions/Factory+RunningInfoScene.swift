//
//  Factory+RunningInfoScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes, resume: Bool) -> UIViewController
    func makeRunningInfoVM() -> RunningInfoViewModelTypes
}

extension DependencyFactory: RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes, resume: Bool) -> UIViewController {
        RunningInfoViewController(with: viewModel, resume: resume)
    }

    func makeRunningInfoVM() -> RunningInfoViewModelTypes {
        RunningInfoViewModel(runningDataProvider: runningDataProvider)
    }
}
