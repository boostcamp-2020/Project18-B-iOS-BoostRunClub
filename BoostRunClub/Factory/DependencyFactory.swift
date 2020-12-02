//
//  ServiceProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import UIKit

protocol Factory: AnyObject {
    //    func makeLoginVC(with viewModel: LoginViewModelTypes) -> UIViewController
    //    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController
    func makeRunningPageVC(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController
    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UIViewController
    //    func makeProfileVC(with viewModel: ProfileViewModelTypes) -> UIViewController
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController
    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController
    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController
    func makeRunningMapVC(with viewModel: RunningMapViewModelTypes) -> UIViewController
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController
    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController

    //    func makeLoginVM() -> LoginViewModelTypes
    //    func makeActivityVM() -> ActivityViewModelTypes
    //    func makeProfileVM() -> ProfileViewModelTypes
    func makeRunningPageVM() -> RunningPageViewModelTypes
    func makePrepareRunVM() -> PrepareRunViewModelTypes
    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes
    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes
    func makeRunningMapVM() -> RunningMapViewModelTypes
    func makeRunningInfoVM() -> RunningInfoViewModelTypes
    func makePausedRunningVM() -> PausedRunningViewModelTypes
}

class DependencyFactory: Factory {
    lazy var runningDataProvider = RunningDataService(locationProvider: locationProvider)
    lazy var locationProvider = LocationProvider()

    func makeRunningPageVC(with _: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController {
        let runningPageVC = RunningPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        runningPageVC.setPages(viewControllers)
        return runningPageVC
    }

    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = selectedIndex
        tabBarController.tabBar.isTranslucent = false // TODO: false true 비교
        return tabBarController
    }

    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController {
        PrepareRunViewController(with: viewModel)
    }

    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController {
        GoalTypeViewController(with: viewModel)
    }

    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController {
        GoalValueSetupViewController(with: viewModel)
    }

    func makeRunningMapVC(with _: RunningMapViewModelTypes) -> UIViewController {
        RunningMapViewController()
    }

    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController {
        RunningInfoViewController(with: viewModel)
    }

    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController {
        PausedRunningViewController(with: viewModel)
    }

    func makeRunningPageVM() -> RunningPageViewModelTypes {
        RunningPageViewModel()
    }

    func makePrepareRunVM() -> PrepareRunViewModelTypes {
        PrepareRunViewModel(locationProvider: locationProvider)
    }

    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes {
        GoalTypeViewModel(goalType: goalType)
    }

    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes {
        GoalValueSetupViewModel(goalType: goalType, goalValue: goalValue)
    }

    func makeRunningMapVM() -> RunningMapViewModelTypes {
        RunningMapViewModel()
    }

    func makeRunningInfoVM() -> RunningInfoViewModelTypes {
        RunningInfoViewModel(runningDataProvider: runningDataProvider)
    }

    func makePausedRunningVM() -> PausedRunningViewModelTypes {
        PausedRunningViewModel(runningDataProvider: runningDataProvider)
    }
}

extension DependencyFactory {}
