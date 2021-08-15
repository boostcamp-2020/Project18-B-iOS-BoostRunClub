//
//  Factory+LoginScene.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol LoginSceneFactory {
    //    func makeLoginVC(with viewModel: LoginViewModelTypes) -> UIViewController
    //    func makeLoginVM() -> LoginViewModelTypes
}

extension DependencyFactory: LoginSceneFactory {}
