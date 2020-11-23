//
//  PrepareRunViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import MapKit
import UIKit

class PrepareRunViewController: UIViewController {
    let mapView = MKMapView()
    weak var delegate: PrepareRunCoordinatorProtocol?

    lazy var setGoalTypeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitle("목표설정", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(12)
        button.layer.cornerRadius = LayoutConstant.setGoalHeight / 2
        button.addTarget(self, action: #selector(didTapSetGoalTypeButton), for: .touchUpInside)
        return button
    }()

    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitle("시작", for: .normal)
        button.layer.cornerRadius = LayoutConstant.buttonWidth / 2
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItems()
        configureLayout()
    }
}

// MARK: - Configure

extension PrepareRunViewController {
    func configureNavigationItems() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true

        let profileItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(showProfileViewController)
        )

        navigationItem.setLeftBarButton(profileItem, animated: true)
    }

    func configureLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        view.addSubview(setGoalTypeButton)
        setGoalTypeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setGoalTypeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            setGoalTypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setGoalTypeButton.widthAnchor.constraint(equalToConstant: LayoutConstant.setGoalWidth),
            setGoalTypeButton.heightAnchor.constraint(equalToConstant: LayoutConstant.setGoalHeight),
        ])

        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: setGoalTypeButton.topAnchor, constant: -10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: LayoutConstant.buttonWidth),
            startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor, multiplier: 1),
        ])
    }
}

// MARK: - Actions

extension PrepareRunViewController {
    @objc
    func showProfileViewController() {}

    @objc
    func didTapStartButton() {}

    @objc
    func didTapSetGoalTypeButton() {
        delegate?.showGoalTypeActionSheet()
    }
}

// MARK: - LayoutConstant

extension PrepareRunViewController {
    enum LayoutConstant {
        static let buttonWidth = CGFloat(80)
        static let setGoalWidth = CGFloat(75)
        static let setGoalHeight = CGFloat(30)
    }
}
