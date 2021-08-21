//
//  GoalValueSetupViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/26.
//

import Combine
import UIKit

class GoalValueSetupViewController: UIViewController {
    var keyboardType: UIKeyboardType = .default
    let goalValueView = GoalValueView()

    var viewModel: GoalValueSetupViewModelTypes?
    var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(with goalValueVM: GoalValueSetupViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        viewModel = goalValueVM
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        keyboardType = viewModel.outputs.goalType == GoalType.distance ? .decimalPad : .numberPad

        viewModel.outputs.goalValueSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.goalValueView.setLabelText(goalValue: value, goalUnit: viewModel.outputs.goalType.unit)
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - ViewController LifeCycle

extension GoalValueSetupViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureLayout()
        bindViewModel()
        goalValueView.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goalValueView.transform = goalValueView.transform.scaledBy(x: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            self.goalValueView.transform = .identity
        }
    }
}

// MARK: - Actions

extension GoalValueSetupViewController {
    @objc
    func didTapCancelItem() {
        viewModel?.inputs.didTapCancelButton()
    }

    @objc
    func didTapApplyItem() {
        viewModel?.inputs.didTapApplyButton()
    }
}

// MARK: UIKeyInput Implementation

extension GoalValueSetupViewController: UIKeyInput {
    var hasText: Bool {
        return false
    }

    func insertText(_ text: String) {
        viewModel?.inputs.didInputNumber(text)
    }

    func deleteBackward() {
        viewModel?.inputs.didDeleteBackward()
    }

    override var canBecomeFirstResponder: Bool { true }
}

// MARK: - Configure

extension GoalValueSetupViewController {
    private func configureLayout() {
        view.addSubview(goalValueView)
        goalValueView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = goalValueView.centerYAnchor.constraint(equalTo: view.topAnchor)
        constraint.constant = UIScreen.main.bounds.height / 3
        NSLayoutConstraint.activate([
            goalValueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            constraint,
        ])
    }

    private func configureNavigationItems() {
        guard let viewModel = viewModel else { return }

        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "목표 \(viewModel.outputs.goalType.description)"

        let cancelItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancelItem)
        )
        cancelItem.tintColor = .label
        navigationItem.setLeftBarButton(cancelItem, animated: true)

        let applyItem = UIBarButtonItem(
            title: "설정",
            style: .plain,
            target: self,
            action: #selector(didTapApplyItem)
        )
        applyItem.tintColor = .label
        navigationItem.setRightBarButton(applyItem, animated: true)
    }
}
