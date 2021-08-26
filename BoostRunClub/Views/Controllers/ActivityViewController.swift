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

    private var activityDataSource = ActivityDataSource()
    private lazy var containerCellView = { activityDataSource.containerCellView }()
    private lazy var collectionView = { containerCellView.collectionView }()

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
        configureTableView()
        collectionView.dataSource = activityDataSource
        configureLayout()
        bindViewModel()
        viewModel?.inputs.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItems()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // outputs
        viewModel.outputs.recentActivitiesSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activityDataSource.loadActivities($0)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.outputs.totalDataSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.activityTotalView.configure(config: $0)
                self?.activityDataSource.loadActivityTotal($0)
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

        containerCellView.didItemSelectedSignal
            .sink { [weak viewModel] in viewModel?.inputs.didSelectActivity(at: $0.row) }
            .store(in: &cancellables)

        containerCellView.didHeightChangeSignal
            .sink {
                guard let path = self.tableView.indexPath(for: $0) else { return }
                self.tableView.reloadRows(at: [path], with: .none)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

extension ActivityViewController {
    @objc
    func showProfileViewController(sender _: UIBarButtonItem) {
        print("프로필컨트롤러보여줘")
        viewModel?.inputs.didTapShowProfileButton()
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
        let title = activityDataSource.statisticHeaderTitle
        if !title.isEmpty, section == 0 {
            label.text = title
        } else {
            label.text = "최근 활동"
        }
        return label
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - Configure

extension ActivityViewController {
    private func configureNavigationItems() {
        navigationItem.title = "활동"
        navigationController?.navigationBar.prefersLargeTitles = true

        let profileItem = UIBarButtonItem.makeProfileButton()
        if let profileButton = profileItem.customView as? UIButton {
            profileButton.addTarget(self,
                                    action: #selector(showProfileViewController(sender:)),
                                    for: .touchUpInside)
        }
        navigationItem.setLeftBarButton(profileItem, animated: false)
    }

    private func configureTableView() {
        tableView.dataSource = activityDataSource
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
