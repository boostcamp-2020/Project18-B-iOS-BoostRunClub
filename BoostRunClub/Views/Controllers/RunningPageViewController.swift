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

    private var pages = [UIViewController]()
    private var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)

        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = Pages.allCases.count
        pageControl.currentPage = 1
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func setPages(_ viewControllers: [UIViewController]) {
        pages.append(contentsOf: viewControllers)
    }
}

extension RunningPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating _: Bool,
        previousViewControllers _: [UIViewController],
        transitionCompleted _: Bool
    ) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = pages.firstIndex(of: viewControllers[0]) {
                pageControl.currentPage = viewControllerIndex
            }
        }
    }
}

extension RunningPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    )
        -> UIViewController?
    {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex == 0 {
                return nil
            } else {
                return pages[viewControllerIndex - 1]
            }
        }
        return nil
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    )
        -> UIViewController?
    {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                return pages[viewControllerIndex + 1]
            } else {
                return nil
            }
        }
        return nil
    }
}
