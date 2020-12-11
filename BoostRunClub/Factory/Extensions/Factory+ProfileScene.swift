//
//  Factory+ProfileScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol ProfileSceneFactory {
    func makeProfileVC(with viewModel: ProfileViewModelTypes) -> UIViewController
    func makeProfileVM() -> ProfileViewModelTypes
}

extension DependencyFactory: ProfileSceneFactory {
    func makeProfileVC(with viewModel: ProfileViewModelTypes) -> UIViewController {
        ProfileViewController(with: viewModel)
    }

    func makeProfileVM() -> ProfileViewModelTypes {
        ProfileViewModel(defaults: defaultsProvider)
    }
}
