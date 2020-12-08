//
//  Factory+ActivityScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol ActivitySceneFactory {
    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController
    func makeActivityVM() -> ActivityViewModelTypes
}

extension DependencyFactory: ActivitySceneFactory {
    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController {
        return ActivityViewController(with: viewModel)
    }

    func makeActivityVM() -> ActivityViewModelTypes {
        return ActivityViewModel(activityProvider: activityProvider)
    }
}
