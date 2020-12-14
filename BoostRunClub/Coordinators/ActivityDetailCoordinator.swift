//
//  ActivityDetailCoordinator.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

final class ActivityDetailCoordinator: BasicCoordinator<Void> {
    let factory: ActivityDetailSceneFactory
    let activity: Activity
    let detail: ActivityDetail?

    init(
        navigationController: UINavigationController,
        activity: Activity,
        detail: ActivityDetail? = nil,
        factory: ActivityDetailSceneFactory = DependencyFactory.shared
    ) {
        self.factory = factory
        self.activity = activity
        self.detail = detail
        super.init(navigationController: navigationController)
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    override func start() {
        showActivityDetailViewController()
    }

    func showActivityDetailViewController() {
        // TODO: detailVM 생성 실패시 처리가 필요함!!!
        guard let detailVM = factory.makeActivityDetailVM(activity: activity, detail: detail) else {
            closeSignal.send()
            return
        }

        let detailVC = factory.makeActivityDetailVC(with: detailVM)
        navigationController.pushViewController(detailVC, animated: true)

        detailVM.outputs.goBackToSceneSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.navigationController.popViewController(animated: true)
                self?.closeSignal.send()
            }
            .store(in: &cancellables)

        detailVM.outputs.showInfoDetailSignal
            .sink { [weak self] in self?.showSplitInfoDetailScene() }
            .store(in: &cancellables)
    }

    func showSplitInfoDetailScene() {
        guard let splitInfoVM = factory.makeSplitInfoDetailVM(activity: activity) else { return }
        let splitInfoVC = factory.makeSplitInfoDetailVC(with: splitInfoVM)
        navigationController.pushViewController(splitInfoVC, animated: true)
    }
}
