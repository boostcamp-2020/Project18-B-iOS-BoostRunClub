//
//  Factory+TabBarContainer.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

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
