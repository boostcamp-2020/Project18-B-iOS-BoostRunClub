//
//  ProfileCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol ProfileCoordinatorProtocol: Coordinator {
    func showProfileViewController()
}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    var navigationController: UINavigationController

    var childCoordinators = [Coordinator]()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showProfileViewController()
    }

    func showProfileViewController() {
        let profileVC = ProfileViewController()
        navigationController.pushViewController(profileVC, animated: true)
    }
}
