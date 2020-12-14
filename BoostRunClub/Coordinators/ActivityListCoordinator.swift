//
//  ActivityAllCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Combine
import UIKit

final class ActivityListCoordinator: BasicCoordinator<Void> {
    let factory: ActivityListSceneFactory

    init(navigationController: UINavigationController, factory: ActivityListSceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    override func start() {
        showActivityListViewController()
    }

    func showActivityListViewController() {
        let listVM = factory.makeActivityListVM()
        let listVC = factory.makeActivityListVC(with: listVM)

        listVM.outputs.goBackToSceneSignal
            .receive(on: RunLoop.main)
            .sink { [weak self, weak listVC] in
                listVC?.navigationController?.popViewController(animated: true)
                self?.closeSignal.send()
            }
            .store(in: &cancellables)

        navigationController.pushViewController(listVC, animated: true)
    }
}
