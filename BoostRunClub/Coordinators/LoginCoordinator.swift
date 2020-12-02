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
    override func start() {
        showLoginViewController()
    }

    func showLoginViewController() {
        let loginVC = LoginViewController()
        navigationController.pushViewController(loginVC, animated: true)
    }
}
