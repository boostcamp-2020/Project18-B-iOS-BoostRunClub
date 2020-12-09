//
//  ProfileViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/23.
//

import UIKit

final class ProfileViewController: UIViewController {
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var nameLabel: UILabel = makeNameLabel()
    private lazy var hometownLabel: UILabel = makeHometownLabel()
    private lazy var bioLabel: UILabel = makeBioLabel()
    private lazy var editProfileButton: UIButton = makeEditProfileButton()

    private var viewModel: ProfileViewModelTypes?

    init(with viewModel: ProfileViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life Cycle

extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
    }
}

// MARK: - Action

extension ProfileViewController {
    @objc
    func didTapEditProfileButton() {
        viewModel?.inputs.didTapEditProfileButton()
    }
}

// MARK: - Configure

extension ProfileViewController {
    func configureLayout() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
        ])

        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
        ])

        view.addSubview(hometownLabel)
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hometownLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            hometownLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
        ])

        view.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bioLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bioLabel.topAnchor.constraint(equalTo: hometownLabel.bottomAnchor, constant: 15),
        ])

        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editProfileButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editProfileButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.SFSymbol(name: "person.crop.square", color: .label)
        return imageView
    }

    func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.text = "IMHO JANG"
        label.textColor = .label
        label.font = UIFont(name: "DIN Condensed Bold", size: 20)
        return label
    }

    func makeHometownLabel() -> UILabel {
        let label = UILabel()
        label.text = "Seoul"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }

    func makeBioLabel() -> UILabel {
        let label = UILabel()
        label.text = "Run for your life!"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }

    func makeEditProfileButton() -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = CGFloat(1)
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.setTitle("EDIT PROFILE", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 70, bottom: 5, right: 70)
        button.titleLabel?.font = UIFont(name: "DIN Condensed Bold", size: 14)
        button.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        return button
    }
}
