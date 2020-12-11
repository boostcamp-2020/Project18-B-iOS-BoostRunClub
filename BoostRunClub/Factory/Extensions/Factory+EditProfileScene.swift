//
//  Factory+EditProfileScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import UIKit

protocol EditProfileSceneFactory {
    func makeEditProfileVC(with viewModel: EditProfileViewModelTypes) -> UIViewController
    func makeEditProfileVM() -> EditProfileViewModelTypes
}

extension DependencyFactory: EditProfileSceneFactory {
    func makeEditProfileVC(with viewModel: EditProfileViewModelTypes) -> UIViewController {
        EditProfileViewController(with: viewModel)
    }

    func makeEditProfileVM() -> EditProfileViewModelTypes {
        EditProfileViewModel(defaults: defaultsProvider)
    }
}
