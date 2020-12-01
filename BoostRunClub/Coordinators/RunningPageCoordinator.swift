//
//  RunningPageCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/30.
//

import Combine
import UIKit

protocol RunningPageCoordinatorProtocol: Coordinator {
    var runningPageController: RunningPageViewController { get set }
}

final class RunningPageCoordinator: RunningPageCoordinatorProtocol {
    var runningPageController = RunningPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()

    private weak var serviceProvider: ServiceProvidable?

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(serviceProvider: ServiceProvidable? = nil) {
        self.serviceProvider = serviceProvider
        prepareRunningPageController()
    }

    private func prepareRunningPageController() {
        childCoordinators = [
            RunningMapCoordinator(UINavigationController()),
            RunningCoordinator(UINavigationController()),
            SplitsCoordinator(UINavigationController()),
        ]

        serviceProvider?.registerService(service: RunningDataProvider())

        childCoordinators.forEach { $0.start(serviceProvider: serviceProvider) }
        runningPageController.setPages(childCoordinators.map { $0.navigationController })
        navigationController.viewControllers = [runningPageController]
    }

    deinit {
        print("finished \(self)")
    }
}
