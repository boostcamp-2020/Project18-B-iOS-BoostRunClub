//
//  SplitInfoDetailViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/13.
//

import UIKit

class SplitInfoDetailViewController: UIViewController {
    let subView = UIView()
    var statusBarView: UIView?
}

// MARK: - Life Cycles

extension SplitInfoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNavigationBar()
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
        statusBarView = navigationController?.setStatusBar(backgroundColor: .systemBackground)
        subView.backgroundColor = .systemPink
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func configureNavigationBar() {
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
