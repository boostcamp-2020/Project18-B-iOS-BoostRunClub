//
//  ActivityDetailViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    var viewModel: ActivityDetailViewModelTypes?

    init(with viewModel: ActivityDetailViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureNavigationItems()
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
}

