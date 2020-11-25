//
//  LoginCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showLoginViewController()
}

final class LoginCoordinator: LoginCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?

    var type: CoordinatorType { .login }

    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showLoginViewController()
    }

    func showLoginViewController() {
        let loginVC = LoginViewController()
        navigationController.pushViewController(loginVC, animated: true)
    }
}
