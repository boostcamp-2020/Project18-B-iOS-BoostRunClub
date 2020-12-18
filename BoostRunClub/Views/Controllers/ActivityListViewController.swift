//
//  ActivityListlViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Combine
import UIKit

class ActivityListViewController: UIViewController {
    private lazy var collectionView = makeCollectionView()
    private var dataSource = ActivityListDataSource()

    private var cancellables = Set<AnyCancellable>()
    private var viewModel: ActivityListViewModelTypes?

    init(with viewModel: ActivityListViewModelTypes) {
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
        bindViewModel()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.activityListItemSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.dataSource.loadData($0)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Actions

extension ActivityListViewController {
    @objc
    func didTapBackItem() {
        viewModel?.inputs.didTapBackItem()
    }
}

// MARK: - UICollectionViewDelegate Implementation

extension ActivityListViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.inputs.didTapActivity(section: indexPath.section, row: indexPath.row)
    }
}

// MARK: - Configure

extension ActivityListViewController {
    private func configureNavigationItems() {
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "모든 활동"

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
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.headerReferenceSize = CGSize(width: width, height: 100)
        layout.estimatedItemSize = CGSize(width: width, height: 100)
        layout.sectionHeadersPinToVisibleBounds = true

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(
            ActivityCellView.self,
            forCellWithReuseIdentifier: "\(ActivityCellView.self)"
        )
        collectionView.register(
            ActivityListHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "\(ActivityListHeaderView.self)"
        )
        return collectionView
    }

    func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}
