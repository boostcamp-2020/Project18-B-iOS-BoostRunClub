//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Combine
import UIKit

final class RunningInfoViewController: UIViewController {
    private lazy var subRunDataStackView: UIStackView = makeRunDataStackView()
    private lazy var pauseButton: UIButton = makePauseButton()
    private var runDataViews: [RunDataView] = [
        RunDataView(style: .main),
        RunDataView(),
        RunDataView(),
        RunDataView(),
    ]

    private var viewModel: RunningInfoViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with runningViewModel: RunningInfoViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = runningViewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        runDataViews.enumerated().forEach { idx, view in
            view.tapAction = { [weak viewModel] in
                viewModel?.inputs.didTapRunData(index: idx)
                view.notificationFeedback()
            }

            viewModel.outputs.runningInfoObservables[idx]
                .receive(on: RunLoop.main)
                .sink { [weak view] runningInfo in
                    view?.setValue(value: runningInfo.value)
                    view?.setType(type: runningInfo.type.name)
                }
                .store(in: &cancellables)
        }

        viewModel.outputs.runningInfoTapAnimation
            .receive(on: RunLoop.main)
            .filter { $0 < self.runDataViews.count }
            .sink { self.runDataViews[$0].startBounceAnimation() }
            .store(in: &cancellables)

        viewModel.outputs.initialAnimation
            .receive(on: RunLoop.main)
            .sink {
                self.startInitialAnimation()
            }
            .store(in: &cancellables)

        viewModel.outputs.resumeAnimation
            .receive(on: RunLoop.main)
            .sink {
                self.startResumeAnimation()
            }
            .store(in: &cancellables)
    }
}

// MARK: - LifeCycle

extension RunningInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)
        configureLayout()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.inputs.viewDidAppear()
    }
}

// MARK: - Actions

extension RunningInfoViewController {
    @objc
    func didTapPauseButton() {
        viewModel?.inputs.didTapPauseButton()
        view.notificationFeedback()
    }

    private func startInitialAnimation() {
        view.subviews.forEach {
            $0.transform = $0.transform.scaledBy(x: 0.5, y: 0.5)
            $0.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.view.subviews.forEach {
                $0.transform = .identity
                $0.alpha = 1
            }
        }
    }

    private func startResumeAnimation() {
        let targetView = runDataViews[0]
        targetView.alpha = 0
        targetView.transform = targetView.transform.scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            targetView.alpha = 1
            targetView.transform = .identity
        }
    }
}

// MARK: - Configure

extension RunningInfoViewController {
    private func makeRunDataStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    private func makePauseButton() -> UIButton {
        let button = CircleButton(with: .pause)
        button.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        return button
    }

    private func configureLayout() {
        runDataViews.dropFirst().forEach { self.subRunDataStackView.addArrangedSubview($0) }
        subRunDataStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subRunDataStackView)

        NSLayoutConstraint.activate([
            subRunDataStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            subRunDataStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subRunDataStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])

        runDataViews[0].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(runDataViews[0])

        NSLayoutConstraint.activate([
            runDataViews[0].bottomAnchor.constraint(equalTo: view.centerYAnchor),
            runDataViews[0].centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)

        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.heightAnchor.constraint(equalToConstant: 100),
            pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor, multiplier: 1),
        ])
    }
}
