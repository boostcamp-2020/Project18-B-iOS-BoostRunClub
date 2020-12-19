//
//  Factory+TabBarContainer.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/06.
//

import UIKit

protocol TabBarContainerFactory {
    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UITabBarController
}

extension DependencyFactory: TabBarContainerFactory {
    func makeTabBarVC(with viewControllers: [UIViewController], selectedIndex: Int) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = selectedIndex
//        tabBarController.tabBar.isTranslucent = false // TODO: false true 비교
        tabBarController.tabBar.tintColor = TabBarPage.selectColor
        tabBarController.tabBar.unselectedItemTintColor = TabBarPage.unselectColor
        tabBarController.tabBar.barTintColor = .systemBackground
        viewControllers[0].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "activity4"), tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "running4"), tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile4"), tag: 2)
        viewControllers.forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        }
        return tabBarController
    }
}
