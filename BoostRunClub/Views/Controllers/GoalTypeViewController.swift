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

    // TODO: goalTypeViewModel에서 선택되어져 있는 값에 체크마크
    private func bindViewModel() {}
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
                [weak self] in
                guard let self = self else { return }
                self.tableView.frame.origin.y = UIScreen.main.bounds.height - self.tableViewHeight
                self.tableView.bounds.origin.y = 0
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
            animations: { [weak self] in
                guard let self = self else { return }
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
        tableView.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.register(GoalTypeCell.self, forCellReuseIdentifier: String(describing: GoalTypeCell.self))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.layer.cornerRadius = 30
        tableView.rowHeight = GoalTypeCell.cellHeight
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
        CGFloat(tableViewCells.count) * GoalTypeCell.cellHeight + verticalTablePadding * 3
    }
}
