//
//  EditProfileViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/09.
//

import UIKit

final class EditProfileViewController: UIViewController {
    private lazy var navBar: UINavigationBar = makeNavigationBar()
    private lazy var navItem: UINavigationItem = makeNavigationItem()

    private var viewModel: EditProfileViewModelTypes?

    init(with viewModel: EditProfileViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life Cycle

extension EditProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureLayout()
    }
}

// MARK: - Action

extension EditProfileViewController {
    @objc
    func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func didTapSaveButton() {}
}

// MARK: - Configure

extension EditProfileViewController {
    func configureLayout() {
        view.addSubview(navBar)

        navBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    func makeNavigationBar() -> UINavigationBar {
        let navBar = UINavigationBar()
        navBar.setItems([navItem], animated: false)
        return navBar
    }

    func makeNavigationItem() -> UINavigationItem {
        let navItem = UINavigationItem()
        navItem.hidesBackButton = true

        let cancelItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        cancelItem.tintColor = .label
        navItem.setLeftBarButton(cancelItem, animated: true)

        let applyItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(didTapSaveButton)
        )
        applyItem.tintColor = .label
        navItem.setRightBarButton(applyItem, animated: true)

        return navItem
    }

    func makeNameTextField() {}

    func makeHometownTextfield() {}

    func makeBioTextfield() {}
}
