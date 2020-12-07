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
}

extension Coordinator {
    func clear() {
        childCoordinators.removeAll()
        navigationController.children.forEach { $0.removeFromParent() }
    }
}

class BasicCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {}

    deinit {
        print("[\(Date())] 🌈Coordinator🌈 \(Self.self) deallocated.")
    }
}
