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

    private var dataSource = ActivityDetailDataSource()

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
        configureNavigations()
        splitsView.tableView.dataSource = dataSource
        configureLayout()
        bindViewModel()
        viewModel?.inputs.viewDidLoad()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.detailConfigSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] config in
                self?.titleView.configure(dateText: config.titleDate, title: config.title)
                self?.totalView.configure(with: config)
                self?.mapContainerView.configure(locations: config.locations, splits: config.splits)
                self?.dataSource.loadData(config.splits)
                self?.splitsView.tableView.reloadData()
            }
            .store(in: &cancellables)

        splitsView.heightChangedPublisher
            .sink { self.contentStack.layoutIfNeeded() }
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

// MARK: - Configure

extension ActivityDetailViewController {
    private func configureNavigations() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

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
