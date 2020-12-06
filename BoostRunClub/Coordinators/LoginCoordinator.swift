//
//  LoginCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol LoginCoordinatorProtocol {
    func showLoginViewController()
}

final class LoginCoordinator: BasicCoordinator, LoginCoordinatorProtocol {
    let factory: LoginSceneFactory

    init(navigationController: UINavigationController, factory: LoginSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showLoginViewController()
    }

    func showLoginViewController() {
        let loginVC = LoginViewController()
        navigationController.pushViewController(loginVC, animated: true)
    }
}
