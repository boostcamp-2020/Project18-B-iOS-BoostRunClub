//
//  ActivityViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

final class ActivityViewController: UIViewController {
    var tableView = ActivityTableView()
    var activitiyCells: [ActivityCellView] = [
        ActivityCellView(),
        ActivityCellView(),
        ActivityCellView(),
        ActivityCellView(),
        ActivityCellView(),
    ]

    var viewModel: ActivityViewModelTypes?

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
        configureNavigationItems()
        configureLayout()
        tableView.register(ActivityCellView.self, forCellReuseIdentifier: String(describing: ActivityCellView.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        bindViewModel()
    }

    private func bindViewModel() {}
}

// MARK: - Actions

extension ActivityViewController {
    @objc
    func showProfileViewController() {
        viewModel?.inputs.didTapShowProfileButton()
    }
}

// MARK: - UITableViewDataSource Implementation

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return activitiyCells.count
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return activitiyCells[indexPath.section]
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "최근 활동" : nil
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 5
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        var label = UILabel()
        label.text = "최근 활동"
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
