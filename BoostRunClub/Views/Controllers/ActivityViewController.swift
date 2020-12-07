//
//  ActivityViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

final class ActivityViewController: UIViewController {
    var tableView = ActivityTableView()
    var activityTotalView = ActivityTotalView()
    let activityFooterView = ActivityFooterView()
    var activitiyCells: [ActivityCellView] = []
    var activityStatisticCells: [UITableViewCell] = []

    var viewModel: ActivityViewModelTypes?
    var cancellables = Set<AnyCancellable>()

    init(with viewModel: ActivityViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemBackground
        configureNavigationItems()
        configureTableView()
        configureLayout()
        bindViewModel()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // outputs
        viewModel.outputs.activitiesSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activitiyCells.removeAll()
                $0.forEach {
                    let cell = ActivityCellView()
                    cell.configure(with: $0)
                    self?.activitiyCells.append(cell)
                }
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.outputs.activityTotal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activityTotalView.configure(activityTotal: $0)
            }
            .store(in: &cancellables)

        viewModel.outputs.activityStatistic
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activityStatisticCells.append(contentsOf: [
                    ActivityStatisticCellView(title: "러닝", value: $0.numRunning),
                    ActivityStatisticCellView(title: "킬로미터", value: $0.distance),
                    ActivityStatisticCellView(title: "평균 페이스", value: $0.avgPace),
                    ActivityStatisticCellView(title: "시간", value: $0.runningTime),
                    ActivityStatisticCellView(title: "고도상승", value: $0.elevation),
                ])
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        // inputs
        activityFooterView.didTapAllActivityButton = { [weak viewModel] in
            viewModel?.inputs.didTapShowAllActivities()
        }

        activityTotalView.didChangeSelectedItem = { [weak viewModel] idx in
            viewModel?.inputs.didFilterChanged(to: idx)
        }

        activityTotalView.didTapShowDateFilter = { [weak viewModel] in
            viewModel?.inputs.didTapShowDateFilter()
        }
    }
}

// MARK: - Actions

extension ActivityViewController {
    @objc
    func showProfileViewController() {
        viewModel?.inputs.didTapShowProfileButton()
    }
}

// MARK: - UITableViewDataSource Implementation

extension ActivityViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return activitiyCells.count + (activityStatisticCells.isEmpty ? 0 : 1)
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 1
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !activityStatisticCells.isEmpty,
           indexPath.section == 0
        {
            return activityStatisticCells[indexPath.row]
        } else {
            return activitiyCells[indexPath.section - (activityStatisticCells.isEmpty ? 0 : 1)]
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension ActivityViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section < 2 ? 50 : 5
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < 2 else { return nil }
        let label = UILabel()
        label.text = section == 0 ? "총 활동 통계" : "최근 활동"
        label.textColor = .label
        return label
    }
}

// MARK: - Configure

extension ActivityViewController {
    private func configureNavigationItems() {
        navigationItem.title = "활동"
        navigationController?.navigationBar.prefersLargeTitles = true

        let profileItem = UIBarButtonItem(
            image: UIImage.SFSymbol(name: "person.circle.fill", color: .systemGray),
            style: .plain,
            target: self,
            action: #selector(showProfileViewController)
        )

        navigationItem.setLeftBarButton(profileItem, animated: true)
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        activityTotalView.selfResizing()
        tableView.tableHeaderView = activityTotalView
        tableView.tableFooterView = activityFooterView
    }

    private func configureLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
