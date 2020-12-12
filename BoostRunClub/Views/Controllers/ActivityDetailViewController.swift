//
//  ActivityDetailViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class ActivityDetailViewController: UIViewController {
    private var scrollView = UIScrollView()
    private var titleView = DetailTitleView()
    private var totalView = DetailTotalView()
    private var mapContainerView = DetailMapView()
    private var splitsView = DetailSplitsView()

    private lazy var contentStack = UIStackView.make(
        with: [titleView, totalView, mapContainerView, splitsView],
        axis: .vertical, alignment: .fill, distribution: .fillProportionally, spacing: 10
    )

    private lazy var dataSource = DetailDataSource()
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: ActivityDetailViewModelTypes?

    init(with viewModel: ActivityDetailViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemBackground
        configureNavigationItems()
        configureLayout()
        splitsView.tableView.dataSource = self
        bindViewModel()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        splitsView.heightChangedPublisher
            .sink {
                self.contentStack.layoutIfNeeded()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

extension ActivityDetailViewController {
    @objc
    func didTapBackItem() {
        viewModel?.inputs.didTapBackItem()
    }
}

// MARK: - UITableViewDelegate Implementation

extension ActivityDetailViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        5
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SimpleSplitViewCell()
        cell.configure(style: indexPath.row == 0 ? .desc : .value)
        return cell
    }
}

// MARK: - Configure

extension ActivityDetailViewController {
    private func configureNavigationItems() {
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = ""

        let backItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(didTapBackItem)
        )
        backItem.image = UIImage.SFSymbol(name: "chevron.left", color: .label)
        navigationItem.setLeftBarButton(backItem, animated: true)
    }

    private func configureLayout() {
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
