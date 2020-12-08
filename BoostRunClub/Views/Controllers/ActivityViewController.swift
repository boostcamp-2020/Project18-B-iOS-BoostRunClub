//
//  ActivityViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import Combine
import UIKit

final class ActivityViewController: UIViewController {
    private var tableView = ActivityTableView()
    private var activityTotalView = ActivityTotalView()
    private let activityFooterView = ActivityFooterView()
    private var activitiyCells: [ActivityCellView] = []
    private var activityStatisticCells: [ActivityStatisticCellView] = [
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
    ]

    var showStatisticCell: Bool = false

    private var viewModel: ActivityViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

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
        viewModel?.inputs.viewDidLoad()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // outputs
        viewModel.outputs.activities
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
                self?.configureActivityTotal(to: $0)
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

    private func configureActivityTotal(to config: ActivityTotalConfig) {
        activityTotalView.configure(config: config)

        switch config.filterType {
        case .week, .month:
            showStatisticCell = false
        case .all, .year:
            showStatisticCell = true
            activityStatisticCells[0].configure(title: "러닝", value: config.numRunningPerWeekText)
            activityStatisticCells[1].configure(title: "킬로미터", value: config.distancePerRunningText)
            activityStatisticCells[2].configure(title: "러닝페이스", value: config.avgPaceText)
            activityStatisticCells[3].configure(title: "시간", value: config.runningTimePerRunningText)
            activityStatisticCells[4].configure(title: "고도 상승", value: config.totalElevationText)
        }
        tableView.reloadData()
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
        return activitiyCells.count + (showStatisticCell ? 1 : 0)
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showStatisticCell {
            return section == 0 ? 5 : 1
        } else {
            return 1
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showStatisticCell,
           indexPath.section == 0
        {
            return activityStatisticCells[indexPath.row]
        } else {
            return activitiyCells[indexPath.section - (showStatisticCell ? 1 : 0)]
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension ActivityViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if showStatisticCell {
            return section < 2 ? 50 : 5
        } else {
            return section < 1 ? 50 : 5
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if showStatisticCell {
            switch section {
            case 0:
                let label = UILabel()
                label.text = "총 활동 통계"
                return label
            case 1:
                let label = UILabel()
                label.text = "최근 활동"
                return label
            default:
                return nil
            }
        }

        if section == 0 {
            let label = UILabel()
            label.text = "최근 활동"
            return label
        }
        return nil
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
