//
//  SplitInfoDetailViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/13.
//

import UIKit

class SplitInfoDetailViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SplitDtailSection, AnyHashable>

    var statusBarView: UIView?
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    lazy var dataSource = createDataSource()

    let splitInfo = SpliInfo()
}

// MARK: - Life Cycles

extension SplitInfoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
        configureDataSource()

        var snapshot = NSDiffableDataSourceSnapshot<SplitDtailSection, AnyHashable>()
        snapshot.appendSections([.total])
        snapshot.appendItems(splitInfo.list)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusBarView?.removeFromSuperview()
    }
}

// MARK: - Configure Layout

extension SplitInfoDetailViewController {
    @objc
    func didTapBackButton() {}
}

// MARK: - Configure Layout

extension SplitInfoDetailViewController {
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        collectionView.backgroundColor = .systemBackground

        collectionView.register(SplitInfoViewCell.self, forCellWithReuseIdentifier: SplitInfoViewCell.identifier)
    }

    func configureDataSource() {
        let headerReg = UICollectionView.SupplementaryRegistration
        <SplitDetailTotalHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { view, _, _ in
            view.dateLabel.text = "수요일"
            view.timeLabel.text = "11:36pm"
        }

        dataSource.supplementaryViewProvider = { view, kind, index in
            if kind == UICollectionView.elementKindSectionHeader {
                return view.dequeueConfiguredReusableSupplementary(using: headerReg, for: index)
            }
            return view.dequeueConfiguredReusableSupplementary(using: headerReg, for: index)
        }
    }

    func createDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SplitInfoViewCell.identifier,
                                                          for: indexPath)
            if let cell = cell as? CellConfigurable,
               let item = item as? CellViewModelTypeBase
            {
                cell.setup(viewModel: item)
            }
            return cell
        }
    }

    enum SplitDtailSection: Int {
        case total, splits
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] idx, env in
            guard let type = SplitDtailSection(rawValue: idx) else { return nil }
            return self?.createLayoutSection(type: type, env: env)
        }

        return layout
    }

    private func createLayoutSection(type: SplitDtailSection, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection

        switch type {
        case .total:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            //            section = NSCollectionLayoutSection(group: group)

            var configuration: UICollectionLayoutListConfiguration
            configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.headerMode = .supplementary
            configuration.footerMode = .none

            section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)

        case .splits:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.9))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
//            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionFooter,
                                                                     alignment: .bottom)
            section.boundarySupplementaryItems = [header]
        }

        return section
    }

    private func configureNavigationBar() {
        statusBarView = navigationController?.setStatusBar(backgroundColor: .systemBackground)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationItem.hidesBackButton = true
        let backButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButtonItem.image = UIImage.SFSymbol(name: "chevron.left", color: .label)
        navigationItem.setLeftBarButton(backButtonItem, animated: true)
    }
}
