//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import MapKit
import UIKit

final class RunningPageViewController: UIPageViewController {
    enum Pages: CaseIterable {
        case map, runningInfo, splits
    }

    private var pageDictionary = [Pages: UIViewController]()

    init(with runningViewModel: RunningViewModelTypes) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        pageDictionary[.map] = RunningMapViewController()
        pageDictionary[.runningInfo] = RunningInfoViewController(with: runningViewModel)
        pageDictionary[.splits] = SplitsViewController()
    }

    required init?(coder _: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let mainVC = pageDictionary[.runningInfo] {
            setViewControllers([mainVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension RunningPageViewController: UIPageViewControllerDelegate {}

extension RunningPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    )
        -> UIViewController?
    {
        guard
            let result = pageDictionary.first(where: { _, value in value == viewController }),
            let previousPage = result.key.prev()
        else { return nil }

        return pageDictionary[previousPage]
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    )
        -> UIViewController?
    {
        guard
            let result = pageDictionary.first(where: { _, value in value == viewController }),
            let nextPage = result.key.next()
        else { return nil }

        return pageDictionary[nextPage]
    }
}
