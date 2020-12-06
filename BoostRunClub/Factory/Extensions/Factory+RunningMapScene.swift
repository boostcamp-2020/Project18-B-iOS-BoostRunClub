//
//  Factory+RunningMapScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol RunningMapSceneFactory {
//    func makeRunningMapVC(with viewModel: RunningMapViewModelTypes) -> UIViewController
//    func makeRunningMapVM() -> RunningMapViewModelTypes
}

extension DependencyFactory: RunningMapSceneFactory {
    func makeRunningMapVC(with _: RunningMapViewModelTypes) -> UIViewController {
        RunningMapViewController()
    }

    func makeRunningMapVM() -> RunningMapViewModelTypes {
        RunningMapViewModel()
    }
}
