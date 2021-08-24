//
//  ActivityCoordinator.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

enum ActivityCoordinationResult {
    case profile
}

final class ActivityCoordinator: BasicCoordinator<ActivityCoordinationResult> {
    let factory: ActivitySceneFactory

    init(navigationController: UINavigationController, factory: ActivitySceneFactory = DependencyFactory.shared) {
        self.factory = factory
        super.init(navigationController: navigationController)
        navigationController.view.backgroundColor = .systemBackground
        navigationController.setNavigationBarHidden(false, animated: true)
    }

    override func start() {
        showActivityViewController()
    }

    func startDetail(activity: Activity, detail: ActivityDetail) {
        showActivityViewController()
        showActivityDetailScene(activity: activity, detail: detail)
    }

    func showActivityViewController() {
        let activityVM = factory.makeActivityVM()
        let activityVC = factory.makeActivityVC(with: activityVM)

        activityVM.outputs.showFilterSheetSignal
            .receive(on: RunLoop.main)
            .compactMap { [weak self] in
                self?.showActivityDateFilterViewController(
                    filterType: $0.type,
                    dateRanges: $0.ranges,
                    currentRange: $0.current
                )
            }
            .flatMap { $0 }
            .compactMap { $0 }
            .sink { [weak activityVM] in
                activityVM?.inputs.didFilterRangeChanged(range: $0)
            }
            .store(in: &cancellables)

        activityVM.outputs.showActivityListSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showActivityListScene() }
            .store(in: &cancellables)

        activityVM.outputs.showActivityDetailSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.showActivityDetailScene(activity: $0) }
            .store(in: &cancellables)

        activityVM.outputs.showProfileSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                let result = ActivityCoordinationResult.profile
                self?.closeSignal.send(result)
            }
            .store(in: &cancellables)

        navigationController.pushViewController(activityVC, animated: true)
    }

    func showActivityDateFilterViewController(
        filterType: ActivityFilterType,
        dateRanges: [DateRange],
        currentRange: DateRange
    ) -> AnyPublisher<DateRange?, Never> {
        let activityDateFilterVM = factory.makeActivityDateFilterVM(
            filterType: filterType,
            dateRanges: dateRanges,
            currentRange: currentRange
        )
        let activityDateFilterVC = factory.makeActivityDateFilterVC(
            with: activityDateFilterVM,
            tabHeight: navigationController.tabBarController?.tabBar.bounds.height ?? 0
        )

        activityDateFilterVC.modalPresentationStyle = .overCurrentContext
        navigationController.topViewController?.present(activityDateFilterVC, animated: false, completion: nil)

        return activityDateFilterVM.outputs.closeSignal
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak activityDateFilterVC] _ in
                (activityDateFilterVC as? ActivityDateFilterViewController)?.closeWithAnimation()
            })
            .eraseToAnyPublisher()
    }

    func showActivityListScene() {
        let activityListCoordinator = ActivityListCoordinator(navigationController: navigationController)
        activityListCoordinator.start()
        let uuid = activityListCoordinator.identifier
        closeSubscription[uuid] = activityListCoordinator.closeSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.release(coordinator: activityListCoordinator) }
    }

    func showActivityDetailScene(activity: Activity, detail: ActivityDetail? = nil) {
        let activityDetailCoordinator = ActivityDetailCoordinator(
            navigationController: navigationController,
            activity: activity,
            detail: detail
        )

        let uuid = activityDetailCoordinator.identifier
        closeSubscription[uuid] = coordinate(coordinator: activityDetailCoordinator)
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.release(coordinator: activityDetailCoordinator) }
    }
}
