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
    private lazy var containerCellView = ActivitiesContainerCellView()
    private lazy var collectionView = { containerCellView.collectionView }()
    private var activityStatisticCells: [ActivityStatisticCellView] = [
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
        ActivityStatisticCellView(),
    ]

    private var statisticHeaderTitle: String = ""
    private var activityDataSource = ActivityDataSource()

    private var viewModel: ActivityViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: ActivityViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        print("activity scene deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemBackground
        configureNavigationItems()
        configureTableView()
        configureCollectionView()
        configureLayout()
        bindViewModel()
        viewModel?.inputs.viewDidLoad()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // outputs
        viewModel.outputs.recentActivitiesSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activityDataSource.loadData($0)
                self?.collectionView.reloadData()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.outputs.totalDataSubject
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

        containerCellView.heightChangedPublisher
            .sink {
                guard let path = self.tableView.indexPath(for: $0) else { return }
                self.tableView.reloadRows(at: [path], with: .none)
            }
            .store(in: &cancellables)
    }

    private func configureActivityTotal(to config: ActivityTotalConfig) {
        activityTotalView.configure(config: config)

        switch config.filterType {
        case .week, .month:
            statisticHeaderTitle = ""
        case .all, .year:
            statisticHeaderTitle = config.filterType == .all ? "총 활동 통계" : config.period + " 통계"
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
        statisticHeaderTitle.isEmpty ? 1 : 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statisticHeaderTitle.isEmpty {
            return 1
        } else {
            return section == 0 ? 5 : 1
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !statisticHeaderTitle.isEmpty,
           indexPath.section == 0
        {
            return activityStatisticCells[indexPath.row]
        } else {
            return containerCellView
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension ActivityViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        60
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        if !statisticHeaderTitle.isEmpty, section == 0 {
            label.text = statisticHeaderTitle
        } else {
            label.text = "최근 활동"
        }
        return label
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UICollectionViewDelegate Implementation

extension ActivityViewController: UICollectionViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.inputs.didSelectActivity(at: indexPath.row)
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

    private func configureCollectionView() {
        collectionView.dataSource = activityDataSource
        collectionView.delegate = self
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        activityTotalView.selfResizing()
        tableView.tableHeaderView = activityTotalView
        tableView.tableFooterView = activityFooterView
        tableView.estimatedRowHeight = 100
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
