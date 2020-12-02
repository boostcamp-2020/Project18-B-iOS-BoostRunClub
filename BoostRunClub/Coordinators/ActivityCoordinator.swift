//
//  ActivityCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol ActivityCoordinatorProtocol {}

final class ActivityCoordinator: BasicCoordinator, ActivityCoordinatorProtocol {
    override func start() {
        showActivityViewController()
    }

    func showActivityViewController() {
        let activityVC = ActivityViewController()
        navigationController.pushViewController(activityVC, animated: true)
    }
}
