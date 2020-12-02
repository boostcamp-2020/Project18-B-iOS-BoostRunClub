//
//  PausedRunningViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import MapKit
import UIKit

class PausedRunningViewController: UIViewController {
    private lazy var mapView: MKMapView = makeMapView()
    private lazy var mapViewHeightConstraint = self.mapView.heightAnchor.constraint(equalToConstant: .zero)

    private lazy var resumeButton: UIButton = makeResumeButton()
    private lazy var resumeButtonInitialCenterXConstraint = self.resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero)

    private lazy var endRunningButton: UIButton = makeEndRunningButton()
    private lazy var endRunningButtonInitialCenterXConstraint = self.endRunningButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero)
    private lazy var subRunDataStackViews: [UIStackView] = [makeRunDataStackView(), makeRunDataStackView()]
    private var runDataViews: [RunDataView] = [
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
    ]

    private var viewModel: PausedRunningViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with pausedRunningViewModel: PausedRunningViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = pausedRunningViewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bindViewModel()
        view.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.inputs.viewDidAppear()
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.outputs.showRunningInfoAnimationSignal
            .receive(on: RunLoop.main)
            .sink { _ in
                self.beginAnimation()
            }
            .store(in: &cancellables)
        viewModel.outputs.closeRunningInfoAnimationSignal
            .receive(on: RunLoop.main)
            .sink { _ in
                self.closeAnimation()
            }
            .store(in: &cancellables)
        viewModel.outputs.runningInfoTapAnimationSignal
            .receive(on: RunLoop.main)
            .sink { self.runDataViews[$0].startBounceAnimation() }
            .store(in: &cancellables)

        let data = viewModel.outputs.runInfoData
        runDataViews.enumerated().forEach { idx, view in
            view.setType(type: data[idx].type.name)
            view.setValue(value: data[idx].value)
            view.tapAction = { self.viewModel?.inputs.didTapRunData(index: idx) }
        }
    }

    func configureLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewHeightConstraint,
        ])

        runDataViews.enumerated().forEach { index, runDataView in
            self.subRunDataStackViews[index / 3].addArrangedSubview(runDataView)
        }
        subRunDataStackViews[0].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subRunDataStackViews[0])

        let topLimit = subRunDataStackViews[0].topAnchor.constraint(
            greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 40
        )
        let spacingToMap = subRunDataStackViews[0].topAnchor.constraint(
            equalTo: mapView.bottomAnchor,
            constant: 40
        )

        spacingToMap.priority = topLimit.priority - 1
        NSLayoutConstraint.activate([
            topLimit,
            spacingToMap,
            subRunDataStackViews[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subRunDataStackViews[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])

        subRunDataStackViews[1].translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subRunDataStackViews[1])

        NSLayoutConstraint.activate([
            subRunDataStackViews[1].topAnchor.constraint(equalTo: subRunDataStackViews[0].bottomAnchor, constant: 20),
            subRunDataStackViews[1].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subRunDataStackViews[1].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])

        view.addSubview(resumeButton)
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resumeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            resumeButtonInitialCenterXConstraint,
            resumeButton.heightAnchor.constraint(equalToConstant: 100),
            resumeButton.widthAnchor.constraint(equalTo: resumeButton.heightAnchor, multiplier: 1),
        ])

        view.addSubview(endRunningButton)
        endRunningButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endRunningButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            endRunningButtonInitialCenterXConstraint,
            endRunningButton.heightAnchor.constraint(equalToConstant: 100),
            endRunningButton.widthAnchor.constraint(equalTo: endRunningButton.heightAnchor, multiplier: 1),
        ])
    }
}

// MARK: - Actions

extension PausedRunningViewController {
    @objc
    func didTapResumeButton() {
        viewModel?.inputs.didTapResumeButton()
    }

    @objc
    func didLongHoldStopRunningButton() {
        viewModel?.inputs.didLongHoldStopRunningButton()
    }

    func beginAnimation() {
        mapViewHeightConstraint.constant = UIScreen.main.bounds.height / 3
        resumeButtonInitialCenterXConstraint.constant = 100
        endRunningButtonInitialCenterXConstraint.constant = -100

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
    }

    func closeAnimation() {
        mapViewHeightConstraint.constant = .zero
        resumeButtonInitialCenterXConstraint.constant = .zero
        endRunningButtonInitialCenterXConstraint.constant = .zero
        view.backgroundColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel?.inputs.closeAnimationEnded()
        }
    }
}

// MARK: - Configure

extension PausedRunningViewController {
    private func makeRunDataStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = MKMapType.standard
        view.userTrackingMode = MKUserTrackingMode.follow
        view.isUserInteractionEnabled = false
        return view
    }

    private func makeResumeButton() -> UIButton {
        let button = CircleButton(with: .resume)
        button.addTarget(self, action: #selector(didTapResumeButton), for: .touchUpInside)
        return button
    }

    private func makeEndRunningButton() -> UIButton {
        let button = CircleButton(with: .stop)
        button.addTarget(self, action: #selector(didLongHoldStopRunningButton), for: .touchUpInside)
        return button
    }
}
