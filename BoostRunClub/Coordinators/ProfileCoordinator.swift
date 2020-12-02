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
    override func start() {
        showProfileViewController()
    }

    func showProfileViewController() {
        let profileVC = ProfileViewController()
        navigationController.pushViewController(profileVC, animated: true)
    }
}
