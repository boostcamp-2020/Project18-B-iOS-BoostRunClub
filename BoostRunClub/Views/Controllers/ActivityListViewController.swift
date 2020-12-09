//
//  ActivityListlViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import UIKit

class ActivityListViewController: UIViewController {
    private var collectionView = ActivityCollectionView()

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
        configureNavigationItems()
        view.backgroundColor = .black
        bindViewModel()
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
    }
}

// MARK: - Actions

extension ActivityListViewController {
    @objc
    func didTapBackItem() {
        viewModel?.inputs.didTapBackItem()
    }
}

// MARK: - Config

extension ActivityListViewController {
    private func configureNavigationItems() {
        guard let viewModel = viewModel else { return }

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
}
