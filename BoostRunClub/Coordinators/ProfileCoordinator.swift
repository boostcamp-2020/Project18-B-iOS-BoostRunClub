//
//  ProfileCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol ProfileCoordinatorProtocol {
    func showProfileViewController()
}

final class ProfileCoordinator: BasicCoordinator, ProfileCoordinatorProtocol {
    let factory: ProfileSceneFactory

    init(navigationController: UINavigationController, factory: ProfileSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showProfileViewController()
    }

    func showProfileViewController() {
        let profileVC = ProfileViewController()
        navigationController.pushViewController(profileVC, animated: true)
    }
}
