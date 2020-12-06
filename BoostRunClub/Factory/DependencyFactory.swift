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
    //    func makeRunningPageVC(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController

    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UIViewController
    //    func makeProfileVC(with viewModel: ProfileViewModelTypes) -> UIViewController
    //    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController
    //    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController
    //    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController
    //    func makeRunningMapVC(with viewModel: RunningMapViewModelTypes) -> UIViewController
    //    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController
    //    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController

    //    func makeLoginVM() -> LoginViewModelTypes
    //    func makeActivityVM() -> ActivityViewModelTypes
    //    func makeProfileVM() -> ProfileViewModelTypes
    //    func makeRunningPageVM() -> RunningPageViewModelTypes
    //    func makePrepareRunVM() -> PrepareRunViewModelTypes
    //    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes
    //    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes
    //    func makeRunningMapVM() -> RunningMapViewModelTypes
    //    func makeRunningInfoVM() -> RunningInfoViewModelTypes
    //    func makePausedRunningVM() -> PausedRunningViewModelTypes
}

protocol TabBarContainerFactory {
    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UIViewController
}

extension DependencyFactory: TabBarContainerFactory {
    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = selectedIndex
        tabBarController.tabBar.isTranslucent = false // TODO: false true 비교
        return tabBarController
    }
}

protocol RunningPageContainerFactory {
    func makeRunningPageVC(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController
    func makeRunningPageVM() -> RunningPageViewModelTypes
}

extension DependencyFactory: RunningPageContainerFactory {
    func makeRunningPageVC(with _: RunningPageViewModelTypes, viewControllers: [UIViewController]) -> UIViewController {
        let runningPageVC = RunningPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        runningPageVC.setPages(viewControllers)
        return runningPageVC
    }

    func makeRunningPageVM() -> RunningPageViewModelTypes {
        RunningPageViewModel()
    }
}

protocol LoginSceneFactory {
    //    func makeLoginVC(with viewModel: LoginViewModelTypes) -> UIViewController
    //    func makeLoginVM() -> LoginViewModelTypes
}

extension DependencyFactory: LoginSceneFactory {}

protocol ActivitySceneFactory {
    //    func makeActivityVC(with viewModel: ActivityViewModelTypes) -> UIViewController
    //    func makeActivityVM() -> ActivityViewModelTypes
}

extension DependencyFactory: ActivitySceneFactory {}

protocol ActivityDetailSceneFactory {
    // func makeActivityDetailVC()
    // func makeActivityDetailVM()
}

extension DependencyFactory: ActivityDetailSceneFactory {}

protocol RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController
    func makeRunningInfoVM() -> RunningInfoViewModelTypes
}

extension DependencyFactory: RunningInfoSceneFactory {
    func makeRunningInfoVC(with viewModel: RunningInfoViewModelTypes) -> UIViewController {
        RunningInfoViewController(with: viewModel)
    }

    func makeRunningInfoVM() -> RunningInfoViewModelTypes {
        RunningInfoViewModel(runningDataProvider: runningDataProvider)
    }
}

protocol PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController
    func makePrepareRunVM() -> PrepareRunViewModelTypes
}

extension DependencyFactory: PrepareRunSceneFactory {
    func makePrepareRunVC(with viewModel: PrepareRunViewModelTypes) -> UIViewController {
        PrepareRunViewController(with: viewModel)
    }

    func makePrepareRunVM() -> PrepareRunViewModelTypes {
        PrepareRunViewModel(locationProvider: locationProvider)
    }
}

protocol PausedRunningSceneFactory {
    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController
    func makePausedRunningVM() -> PausedRunningViewModelTypes
}

extension DependencyFactory: PausedRunningSceneFactory {
    func makePausedRunningVC(with viewModel: PausedRunningViewModelTypes) -> UIViewController {
        PausedRunningViewController(with: viewModel)
    }

    func makePausedRunningVM() -> PausedRunningViewModelTypes {
        PausedRunningViewModel(runningDataProvider: runningDataProvider)
    }
}

protocol SplitSceneFactory {
//    func makeSplitVC()
//    func makeSplitVM()
}

extension DependencyFactory: SplitSceneFactory {}

protocol ProfileSceneFactory {
    //    func makeProfileVC(with viewModel: ProfileViewModelTypes) -> UIViewController
    //    func makeProfileVM() -> ProfileViewModelTypes
}

extension DependencyFactory: ProfileSceneFactory {}

protocol GoalTypeSceneFactory {
//    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController
//    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes
}

extension DependencyFactory: GoalTypeSceneFactory {
    func makeGoalTypeVC(with viewModel: GoalTypeViewModelTypes) -> UIViewController {
        GoalTypeViewController(with: viewModel)
    }

    func makeGoalTypeVM(goalType: GoalType) -> GoalTypeViewModelTypes {
        GoalTypeViewModel(goalType: goalType)
    }
}

protocol RunningMapSceneFactory {
//    func makeRunningMapVC(with viewModel: RunningMapViewModelTypes) -> UIViewController
//    func makeRunningMapVM() -> RunningMapViewModelTypes
}

extension DependencyFactory: RunningMapSceneFactory {
    func makeRunningMapVC(with _: RunningMapViewModelTypes) -> UIViewController {
        RunningMapViewController()
    }

    func makeRunningMapVM() -> RunningMapViewModelTypes {
        RunningMapViewModel()
    }
}

protocol GoalValueSetupSceneFactory {
    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController
    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes
}

extension DependencyFactory: GoalValueSetupSceneFactory {
    func makeGoalValueSetupVC(with viewModel: GoalValueSetupViewModelTypes) -> UIViewController {
        GoalValueSetupViewController(with: viewModel)
    }

    func makeGoalValueSetupVM(goalType: GoalType, goalValue: String) -> GoalValueSetupViewModelTypes {
        GoalValueSetupViewModel(goalType: goalType, goalValue: goalValue)
    }
}

class DependencyFactory {
    static let shared = DependencyFactory()
    lazy var coreDataService = CoreDataService()

    lazy var runningDataProvider = RunningDataService(
        locationProvider: locationProvider,
        motionProvider: motionProvider,
        activityWriter: ActivityProvider(coreDataService: coreDataService)
    )

    lazy var locationProvider = LocationProvider()
    lazy var motionProvider = MotionProvider()
}
