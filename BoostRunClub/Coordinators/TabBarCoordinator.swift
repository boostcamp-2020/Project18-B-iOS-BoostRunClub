//
//  TabBarCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

enum TabBarPage: Int {
    case activity
    case running
    case profile

    var selectIcon: UIImage? {
        switch self {
        case .activity:
            return UIImage(named: "activity")
        case .running:
            return UIImage(named: "running")
        case .profile:
            return UIImage(named: "profile")
        }
    }

    static var selectColor: UIColor { .black }
    static var unselectColor: UIColor { .gray }
}

enum MainTabCoordinationResult {
    case running(GoalInfo)
}

final class MainTabBarCoordinator: BasicCoordinator<MainTabCoordinationResult> {
    let factory: TabBarContainerFactory

    init(navigationController: UINavigationController, factory: TabBarContainerFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
    }

    override func start() {
        showTabBarController()
    }

    func start(activity: Activity, detail: ActivityDetail) {
        showTabBarController(activity: activity, detail: detail)
    }

    private func showTabBarController(activity: Activity? = nil, detail: ActivityDetail? = nil) {
        let activityCoordinator = ActivityCoordinator(navigationController: UINavigationController())
        let prepareRunCoordinator = PrepareRunCoordinator(navigationController: UINavigationController())
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())

        let startPage: TabBarPage
        if
            let activity = activity,
            let detail = detail
        {
            childCoordinators[activityCoordinator.identifier] = activityCoordinator
            activityCoordinator.startDetail(activity: activity, detail: detail)
            startPage = .activity
        } else {
            coordinate(coordinator: activityCoordinator)
            startPage = .running
        }

        coordinate(coordinator: profileCoordinator)
        let closablePublisher = coordinate(coordinator: prepareRunCoordinator)

        let tabBarController = factory.makeTabBarVC(
            with: [
                activityCoordinator.navigationController,
                prepareRunCoordinator.navigationController,
                profileCoordinator.navigationController,
            ],
            selectedIndex: startPage.rawValue
        )
        navigationController.viewControllers = [tabBarController]

        let uuid = prepareRunCoordinator.identifier
        closeSubscription[uuid] = closablePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                switch $0 {
                case let .run(info):
                    let result = MainTabCoordinationResult.running(info)
                    self?.closeSignal.send(result)
                }
                self?.release(coordinator: activityCoordinator)
                self?.release(coordinator: prepareRunCoordinator)
                self?.release(coordinator: profileCoordinator)
            }
    }
}
