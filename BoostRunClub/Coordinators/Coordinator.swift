//
//  Coordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

protocol Coordinator: AnyObject {
    var identifier: UUID { get }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [UUID: Coordinator] { get set }
    func start()
}

extension Coordinator {
    func clear() {
        childCoordinators.removeAll()
        navigationController.children.forEach { $0.removeFromParent() }
    }
}
