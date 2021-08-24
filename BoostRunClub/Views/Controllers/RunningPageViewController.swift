//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import AVFoundation
import Combine
import MapKit
import UIKit

final class RunningPageViewController: UIPageViewController {
    enum Pages: CaseIterable {
        case map, info, splits
    }

    private var pages = [UIViewController]()
    private lazy var pageControl = makePageControl()
    private lazy var backButton = makeBackButton()

    private var viewModel: RunningPageViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    private var distance: CGFloat = 0
    private let buttonHeight: CGFloat = 50

    private let synthesizer = AVSpeechSynthesizer()

    init(with viewModel: RunningPageViewModelTypes, viewControllers: [UIViewController]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.viewModel = viewModel
        pages = viewControllers
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        viewModel?.outputs.scaleOnDraggingSubject
            .sink { [weak self] in
                self?.transformBackButton(scale: CGFloat(abs($0)))
                self?.backButton.setArrowImage(dir: $0 > 0 ? .left : .right)
            }
            .store(in: &cancellables)

        viewModel?.outputs.scaleOnSlidingSubject
            .sink { [weak self] in self?.transformBackButton(scale: CGFloat($0)) }
            .store(in: &cancellables)

        viewModel?.outputs.backToPageMainSignal
            .sink { [weak self] in self?.goBackToMainPage(currPageIdx: $0) }
            .store(in: &cancellables)

        viewModel?.outputs.runningTimeSubject
            .sink { [weak self] in self?.backButton.setTitle($0, for: .normal) }
            .store(in: &cancellables)

        viewModel?.outputs.setPageSignal
            .sink { [weak self] in
                guard let self = self else { return }
                self.setViewControllers([self.pages[$0]], direction: .forward, animated: false)
            }
            .store(in: &cancellables)

        viewModel?.outputs.speechSignal
            .sink { [weak self] (speechText: String) in
                self?.speech(text: speechText)
            }
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
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - ViewModel Output Action

extension RunningPageViewController {
    func transformBackButton(scale: CGFloat) {
        backButton.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: scale * distance)
            .scaledBy(x: scale, y: scale)
        pageControl.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: scale * distance)

        UIView.animate(withDuration: 0) {
            self.pageControl.alpha = 1 - scale * 3
        }
    }

    func goBackToMainPage(currPageIdx: Int) {
        let direction: UIPageViewController.NavigationDirection = currPageIdx < 1 ? .forward : .reverse
        setViewControllers([pages[1]], direction: direction, animated: true) { _ in
            self.viewModel?.inputs.didChangeCurrentPage(idx: 1)
        }
    }
}

// MARK: - Actions

extension RunningPageViewController {
    @objc func didTabBackButton() {
        viewModel?.inputs.didTapGoBackButton()
    }

    @objc func panGestureAction() {
        viewModel?.inputs.dragging()
    }
}

// MARK: - Configure

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
            backButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }

    func makePageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.numberOfPages = Pages.allCases.count
        pageControl.currentPage = 1
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }

    func makeBackButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = buttonHeight / 2
        button.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
        return button
    }
}

// MARK: - UIScrollViewDelegate

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

// MARK: - UIPageViewControllerDelegate

extension RunningPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating _: Bool,
        previousViewControllers _: [UIViewController],
        transitionCompleted _: Bool
    ) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = pages.firstIndex(of: viewControllers[0]) {
                viewModel?.inputs.didChangeCurrentPage(idx: viewControllerIndex)
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

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

// MARK: - UIGestureRecognizerDelegate

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

// MARK: - Private Methods

extension RunningPageViewController {
    private func speech(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5

        synthesizer.speak(utterance)
    }
}
