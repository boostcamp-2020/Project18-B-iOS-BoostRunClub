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
    private lazy var mapView: MKMapView = makeMapView()
    private lazy var mapGradientLayer: CAGradientLayer = makeGradientLayer()
    private lazy var setGoalTypeButton: UIButton = makeSetGoalTypeButton()
    private lazy var startButton: UIButton = makeStartButton()
    private lazy var goalValueView: GoalValueView = makeGoalValueView()

    var viewModel: PrepareRunViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(with prepareRunVM: PrepareRunViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        viewModel = prepareRunVM
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.outputs.userLocationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinate in
                let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                self?.mapView.setRegion(viewRegion, animated: false)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(viewModel.outputs.goalTypeSubject, viewModel.outputs.goalValueSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goalType, goalValue in
                if goalType == .none {
                    self?.goalValueView.isHidden = true
                } else {
                    self?.goalValueView.isHidden = false
                    self?.goalValueView.setLabelText(goalValue: goalValue, goalUnit: goalType.unit)
                }
            }
            .store(in: &cancellables)

        viewModel.outputs.goalTypeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] goalType in
                self?.setGoalTypeButton.setTitle(goalType.description, for: .normal)
            }
            .store(in: &cancellables)

        viewModel.outputs.goalValueSetupAnimationSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.goalValueViewShrinkToOriginalSizeAnimation()
            }
            .store(in: &cancellables)

        viewModel.outputs.goalTypeSetupAnimationSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.goalValueViewCrossDissolveAnimation()
            }
            .store(in: &cancellables)

        viewModel.outputs.countDownAnimation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.countDownAnimation() }
            .store(in: &cancellables)

        goalValueView.tapAction = { [weak viewModel] in
            viewModel?.inputs.didTapGoalValueButton()
        }
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - ViewController LifeCycle

extension PrepareRunViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItems()
    }
}

// MARK: - Actions

extension PrepareRunViewController {
    @objc
    func showProfileViewController(sender _: UIBarButtonItem) {
        print("showprofile view controller")
        viewModel?.inputs.didTapShowProfileButton()
    }

    @objc
    func didTapStartButton() {
        viewModel?.inputs.didTapStartButton()
    }

    @objc
    func didTapSetGoalTypeButton() {
        viewModel?.inputs.didTapSetGoalButton()
        view.notificationFeedback()
        setGoalTypeButton.transform = .identity
    }

    @objc
    func didTouchDownSetGoalTypeButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = button.transform.scaledBy(x: 0.9, y: 0.9)
        }
    }

    @objc
    func didTouchUpOutsideSetGoalTypeButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = .identity
        }
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

    private func goalValueViewShrinkToOriginalSizeAnimation() {
        goalValueView.transform = goalValueView.transform.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3) {
            self.goalValueView.transform = .identity
        }
    }

    private func goalValueViewCrossDissolveAnimation() {
        UIView.animate(
            withDuration: 0,
            animations: { self.goalValueView.isHidden = true },
            completion: { _ in
                UIView.transition(
                    with: self.goalValueView,
                    duration: 0.3,
                    options: [.transitionCrossDissolve],
                    animations: nil,
                    completion: { _ in self.goalValueView.isHidden = false }
                )
            }
        )
    }

    private func countDownAnimation() {
        let countDownView = CountDownView(frame: UIScreen.main.bounds)
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(countDownView)
        countDownView.startCountingAnimation(count: 3, completion: {
            countDownView.removeFromSuperview()
            self.viewModel?.inputs.countDownAnimationFinished()
        })
    }
}

// MARK: - LayoutConstant

extension PrepareRunViewController {
    enum LayoutConstant {
        static let startButtonDiameter = CGFloat(115)
        static let setGoalWidth = CGFloat(100)
        static let setGoalHeight = CGFloat(40)
    }
}

// MARK: - Configure

extension PrepareRunViewController {
    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.setRegion(MKCoordinateRegion(center: view.userLocation.coordinate,
                                          latitudinalMeters: 500,
                                          longitudinalMeters: 500),
                       animated: false)
        view.mapType = MKMapType.standard
        view.userTrackingMode = MKUserTrackingMode.follow
        view.isUserInteractionEnabled = false
        return view
    }

    private func makeGradientLayer() -> CAGradientLayer {
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
    }

    private func makeSetGoalTypeButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitle("목표설정", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(14)
        button.layer.cornerRadius = LayoutConstant.setGoalHeight / 2
        button.addTarget(self, action: #selector(didTapSetGoalTypeButton), for: .touchUpInside)
        button.addTarget(self, action: #selector(didTouchDownSetGoalTypeButton), for: .touchDown)
        button.addTarget(self, action: #selector(didTouchUpOutsideSetGoalTypeButton), for: .touchUpOutside)

        return button
    }

    private func makeStartButton() -> UIButton {
        let button = CircleButton(with: .start)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)

        return button
    }

    private func makeGoalValueView() -> GoalValueView {
        let view = GoalValueView()
        view.isHidden = true
        return view
    }

    private func configureNavigationItems() {
        navigationItem.title = "러닝"
        navigationController?.navigationBar.prefersLargeTitles = true

        let profileItem = UIBarButtonItem.makeProfileButton()
        if let profileButton = profileItem.customView as? UIButton {
            profileButton.addTarget(self,
                                    action: #selector(showProfileViewController(sender:)),
                                    for: .touchUpInside)
        }
        navigationItem.setLeftBarButton(profileItem, animated: false)
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
            setGoalTypeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            setGoalTypeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setGoalTypeButton.widthAnchor.constraint(equalToConstant: LayoutConstant.setGoalWidth),
            setGoalTypeButton.heightAnchor.constraint(equalToConstant: LayoutConstant.setGoalHeight),
        ])

        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: setGoalTypeButton.topAnchor, constant: -12),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: LayoutConstant.startButtonDiameter),
            startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor, multiplier: 1),
        ])

        view.addSubview(goalValueView)
        goalValueView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goalValueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goalValueView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 3),
        ])
    }
}
