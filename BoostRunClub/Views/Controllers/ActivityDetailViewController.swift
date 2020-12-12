//
//  ActivityDetailViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    private lazy var collectionView = makeCollectionView()
    private var splitContainerView = DetailSplitsContainerCellView()

    private lazy var dataSource = DetailDataSource()
    var viewModel: ActivityDetailViewModelTypes?

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
        splitContainerView.tableView.dataSource = dataSource
        bindViewModel()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
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

    private func makeCollectionView() -> UICollectionView {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.dataSource = dataSource
        view.register(DetailTotalCellView.self, forCellWithReuseIdentifier: "\(DetailTotalCellView.self)")
        view.register(DetailTitleCellView.self, forCellWithReuseIdentifier: "\(DetailTitleCellView.self)")
        view.register(DetailMapCellView.self, forCellWithReuseIdentifier: "\(DetailMapCellView.self)")
        view.register(DetailSplitsContainerCellView.self, forCellWithReuseIdentifier: "\(DetailSplitsContainerCellView.self)")

        return view
    }

    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
