//
//  ActivityDetailCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

final class ActivityDetailCoordinator: BasicCoordinator {
    let factory: ActivityDetailSceneFactory
    let activity: Activity

    init(navigationController: UINavigationController, activity: Activity, factory: ActivityDetailSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        self.activity = activity
        super.init(navigationController: navigationController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    override func start() {
        showActivityDetailViewController()
    }

    func showActivityDetailViewController() {
        // TODO: detailVM 생성 실패시 처리가 필요함!!!
        guard let detailVM = factory.makeActivityDetailVM(activity: activity) else { return }
        let detailVC = factory.makeActivityDetailVC(with: detailVM)

        navigationController.pushViewController(detailVC, animated: true)
    }
}
