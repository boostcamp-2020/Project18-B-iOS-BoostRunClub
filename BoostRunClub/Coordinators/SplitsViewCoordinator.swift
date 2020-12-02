//
//  SplitsViewCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import UIKit

protocol SplitsCoordinatorProtocol {
    func showSplitsViewController()
}

final class SplitsCoordinator: BasicCoordinator, SplitsCoordinatorProtocol {
    override func start() {
        showSplitsViewController()
    }

    func showSplitsViewController() {
        let splitsVC = SplitsViewController()
        navigationController.pushViewController(splitsVC, animated: true)
    }
}
