//
//  Coordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func clear()
    init(navigationController: UINavigationController, factory: Factory)
}

extension Coordinator {
    func clear() {
        childCoordinators.removeAll()
    }
}

class BasicCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()
    var factory: Factory

    required init(navigationController: UINavigationController, factory: Factory) {
        self.navigationController = navigationController
        self.factory = factory
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {}
}
