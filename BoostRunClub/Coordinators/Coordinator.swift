//
//  Coordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func clear()
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func clear() {
        childCoordinators.removeAll()
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
