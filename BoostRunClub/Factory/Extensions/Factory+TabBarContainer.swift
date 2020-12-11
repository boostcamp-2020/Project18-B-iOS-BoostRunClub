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
//        tabBarController.tabBar.isTranslucent = false // TODO: false true 비교
        tabBarController.tabBar.tintColor = TabBarPage.selectColor
        tabBarController.tabBar.unselectedItemTintColor = TabBarPage.unselectColor
        viewControllers[0].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "activity"), tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "running"), tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), tag: 2)

        return tabBarController
    }
}
