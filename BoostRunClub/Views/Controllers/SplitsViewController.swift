//
//  SplitsViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/27.
//

import Combine
import UIKit

class SplitsViewController: UIViewController {
    private lazy var headerView = makeHeaderView()
    private lazy var tableView = makeTableView()
    private var viewModel: SplitsViewModelTypes?
    private var cancellabls = Set<AnyCancellable>()
    private let rowHeight: CGFloat = 60

    init(with viewModel: SplitsViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        viewModel?.outputs.rowViewModelSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard
                    let self = self,
                    !$0.isEmpty
                else { return }

                self.tableView.reloadData()
                let indexPath = IndexPath(row: $0.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            .store(in: &cancellabls)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycle

extension SplitsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureLayout()
        bindViewModel()
    }
}

// MARK: - TableView

extension SplitsViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        rowHeight
    }

    // DataSource
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.outputs.rowViewModelSubject.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RunningSplitCell.identifier, for: indexPath)

        if let cell = cell as? CellConfigurable,
           let viewModel = viewModel?.outputs.rowViewModelSubject.value[indexPath.row]
        {
            cell.setup(viewModel: viewModel)
        }

        cell.isUserInteractionEnabled = false
        return cell
    }
}

// MARK: - Configure

extension SplitsViewController {
    private func configureNavigationItems() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.title = "구간"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureLayout() {
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        tableView.tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = headerView.topAnchor.constraint(equalTo: tableView.topAnchor)
        topAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            // 이건 왜 안되는거지?
//            headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -40),
            topAnchor,
            headerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: rowHeight),
        ])
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(RunningSplitCell.self,
                           forCellReuseIdentifier: RunningSplitCell.identifier)
        return tableView
    }

    private func makeHeaderView() -> UIView {
        SplitHeaderView(titles: ["킬로미터", "페이스", "편차"])
    }
}
