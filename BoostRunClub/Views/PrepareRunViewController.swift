//
//  PrepareRunViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import CoreLocation
import MapKit
import UIKit

final class PrepareRunViewController: UIViewController {
    let mapView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = MKMapType.standard
        view.userTrackingMode = MKUserTrackingMode.follow
        return view
    }()

    private lazy var mapGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.colors = [
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0.5).cgColor,
            UIColor.systemBackground.cgColor,
        ]
        layer.locations = [0, 0.2, 0.7, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = LayoutConstant.startButtonDiameter / 2
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()

    var viewModel: PrepareRunViewModelTypes?
    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.outputs.userLocation
            .receive(on: DispatchQueue.main)
            .sink { coordinate in
                let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                self.mapView.setRegion(viewRegion, animated: false)
            }
            .store(in: &cancellables)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mapGradientLayer.colors = [
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.systemBackground.withAlphaComponent(0.5).cgColor,
            UIColor.systemBackground.cgColor,
        ]
    }
}

// MARK: - ViewController LifeCycle

extension PrepareRunViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        configureLayout()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapGradientLayer.frame = mapView.bounds

        setGoalTypeButton.layer.shadowPath = UIBezierPath(rect: setGoalTypeButton.bounds).cgPath
        setGoalTypeButton.layer.shadowColor = UIColor.lightGray.cgColor
        setGoalTypeButton.layer.shadowRadius = 50
        setGoalTypeButton.layer.shadowOffset = .zero
        setGoalTypeButton.layer.shadowOpacity = 0.5
    }
}

// MARK: - Configure

extension PrepareRunViewController {
    private func configureNavigationItems() {
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

    private func configureLayout() {
        view.addSubview(mapView)
        mapView.layer.addSublayer(mapGradientLayer)
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
            startButton.heightAnchor.constraint(equalToConstant: LayoutConstant.startButtonDiameter),
            startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor, multiplier: 1),
        ])
    }
}

// MARK: - Actions

extension PrepareRunViewController {
    @objc
    func showProfileViewController() {
        viewModel?.inputs.didTapShowProfileButton()
    }

    @objc
    func didTapStartButton() {
        viewModel?.inputs.didTapStartButton()
    }

    @objc
    func didTapSetGoalTypeButton() {
        viewModel?.inputs.didTapSetGoalButton()
    }
}

// MARK: - LayoutConstant

extension PrepareRunViewController {
    enum LayoutConstant {
        static let startButtonDiameter = CGFloat(100)
        static let setGoalWidth = CGFloat(90)
        static let setGoalHeight = CGFloat(40)
    }
}
