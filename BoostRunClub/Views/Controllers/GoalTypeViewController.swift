//
//  GoalTypeViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

final class GoalTypeViewController: UIViewController {
    private lazy var tableView = loadTableView()
    private var tableViewCells = [
        GoalTypeCell(GoalType.distance),
        GoalTypeCell(GoalType.time),
        GoalTypeCell(GoalType.speed),
    ]
    private var viewModel: GoalTypeViewModelTypes?
    private var cancellables: Set<AnyCancellable> = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(with goalTypeViewModel: GoalTypeViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        viewModel = goalTypeViewModel
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.goalTypeSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] goalType in
                self?.tableViewCells.forEach {
                    if goalType == .none {
                        $0.setStyle(with: .black)
                    } else {
                        $0.setStyle(with: goalType == $0.goalType ? .checked : .gray)
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.outputs.closeSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.closeWithAnimation() }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - ViewController LifeCycle

extension GoalTypeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)

        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.tableView.frame.origin.y = UIScreen.main.bounds.height - self.tableViewHeight
                self.tableView.bounds.origin.y = 0
                self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
            },
            completion: nil
        )
    }
}

// MARK: - Actions

extension GoalTypeViewController {
    @objc
    func didTapBackgroundView(gesture: UITapGestureRecognizer) {
        if !tableView.point(inside: gesture.location(in: tableView), with: nil) {
            viewModel?.inputs.didTapBackgroundView()
        }
    }

    @objc
    func didTapClearButton() {
        viewModel?.inputs.didSelectGoalType(.none)
    }

    func closeWithAnimation() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.tableView.frame.origin.y = UIScreen.main.bounds.height
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            },
            completion: { _ in
                self.dismiss(animated: false, completion: nil)
            }
        )
    }
}

// MARK: - UITableViewDelegate Implementation

extension GoalTypeViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.inputs.didSelectGoalType(tableViewCells[indexPath.row].goalType)
    }
}

// MARK: - UITableViewDataSource Implementation

extension GoalTypeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableViewCells.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
}

// MARK: - Configure

extension GoalTypeViewController {
    private func loadTableView() -> UITableView {
        let size = CGSize(width: UIScreen.main.bounds.width, height: tableViewHeight)
        let origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        let tableView = UITableView(frame: CGRect(origin: origin, size: size), style: .plain)
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.register(GoalTypeCell.self, forCellReuseIdentifier: String(describing: GoalTypeCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.layer.cornerRadius = 25
        tableView.rowHeight = GoalTypeCell.LayoutConstant.cellHeight
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: verticalTablePadding))
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: verticalTablePadding * 2))
        let clearButton = UIButton()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("지우기", for: .normal)
        clearButton.setTitleColor(.label, for: .normal)
        footer.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: footer.topAnchor, constant: 0),
            clearButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

        return tableView
    }

    private var verticalTablePadding: CGFloat { 30 }

    private var tableViewHeight: CGFloat {
        CGFloat(tableViewCells.count) * GoalTypeCell.LayoutConstant.cellHeight + verticalTablePadding * 3
    }
}
