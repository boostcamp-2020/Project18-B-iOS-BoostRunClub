//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import MapKit
import UIKit

extension RunningPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.inputs.buttonScaleShouldUpdate(
            contentOffset: Double(scrollView.contentOffset.x),
            screenWidth: Double(view.bounds.width)
        )
    }

    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate _: Bool) {
        viewModel?.inputs.didEndDragging()
    }

    func scrollViewWillBeginDragging(_: UIScrollView) {
        viewModel?.inputs.willBeginDragging()
    }
}

extension RunningPageViewController {
    func transformBackButton(scale: CGFloat) {
        backButton.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: scale * distance)
            .scaledBy(x: scale, y: scale)
    }

    func goBackToMainPage(currPageIdx: Int) {
        let direction: UIPageViewController.NavigationDirection = currPageIdx < 1 ? .forward : .reverse

        setViewControllers([pages[1]], direction: direction, animated: true) { _ in
            self.viewModel?.inputs.didChangeCurrentPage(idx: 1)
        }
    }
}

final class RunningPageViewController: UIPageViewController {
    enum Pages: CaseIterable {
        case map, info, splits
    }

    var scale: CGFloat = 0

    private var pages = [UIViewController]()
    private lazy var pageControl = makePageControl()
    private lazy var backButton = makeBackButton()

    var viewModel: RunningPageViewModelTypes?
    var cancellables = Set<AnyCancellable>()

    var distance: CGFloat = 0
    let buttonHeight: CGFloat = 40

    var scrollView: UIScrollView?

    init(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.viewModel = viewModel
        pages = viewControllers
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var scaleCancellable: AnyCancellable?

    func bindViewModel() {
        viewModel?.outputs.scaleSubject
            .sink { self.transformBackButton(scale: CGFloat($0)) }
            .store(in: &cancellables)

        viewModel?.outputs.scaleSubjectNotDragging
            .sink { self.transformBackButton(scale: CGFloat($0)) }
            .store(in: &cancellables)

        viewModel?.outputs.goBackToMainPageSignal
            .sink { self.goBackToMainPage(currPageIdx: $0) }
            .store(in: &cancellables)

        viewModel?.outputs.runningTimeSubject
            .receive(on: RunLoop.main)
            .sink { self.backButton.setTitle($0, for: .normal) }
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePageViewController()
        configureSubViews()
        bindViewModel()

        view.layoutIfNeeded()
        distance = view.bounds.height - pageControl.center.y - buttonHeight / 2 - 30
    }

    deinit {
        print("[\(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

extension RunningPageViewController {
    @objc func didTabBackButton() {
        viewModel?.inputs.didTapGoBackButton()
    }

    @objc func panGestureAction() {
        viewModel?.inputs.dragging()
    }
}

extension RunningPageViewController {
    func configurePageViewController() {
        dataSource = self
        delegate = self
        setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)

        view.subviews.forEach { view in
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                self.scrollView = scrollView
            }
        }
    }

    func configureSubViews() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }

    func makePageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = Pages.allCases.count
        pageControl.currentPage = 1
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }

    func makeBackButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
        return button
    }
}

extension RunningPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers _: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if finished, completed, let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = pages.firstIndex(of: viewControllers[0]) {
                pageControl.currentPage = viewControllerIndex
                viewModel?.inputs.didChangeCurrentPage(idx: viewControllerIndex)
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

extension RunningPageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    )
        -> Bool
    {
        true
    }
}
