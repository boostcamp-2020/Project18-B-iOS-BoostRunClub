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
    private lazy var resumeButton: UIButton = makeResumeButton()
    private lazy var endRunningButton = CircleLongPressButton(with: .stop, scaleRatio: 1.3, duration: 1)
    private lazy var subRunDataStackViews: [UIStackView] = [makeRunDataStackView(), makeRunDataStackView()]
    private var runDataViews: [RunDataView] = [
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
        RunDataView(),
    ]

    private lazy var mapViewHeightConstraint = self.mapView.heightAnchor.constraint(equalToConstant: .zero)
    private lazy var resumeButtonInitialCenterXConstraint
        = self.resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero)
    private lazy var endRunningButtonInitialCenterXConstraint
        = self.endRunningButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: .zero)

    private var viewModel: PausedRunningViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    private var timer: Timer?
    private var pressed: Bool = false
    var color: UIColor?

    init(with pausedRunningViewModel: PausedRunningViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = pausedRunningViewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.showRunningInfoAnimationSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.beginAnimation() }
            .store(in: &cancellables)

        viewModel.outputs.closeRunningInfoAnimationSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.closeAnimation() }
            .store(in: &cancellables)

        viewModel.outputs.runningInfoTapAnimationSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] index in self?.runDataViews[index].startBounceAnimation() }
            .store(in: &cancellables)

        let data = viewModel.outputs.runInfoData
        runDataViews.enumerated().forEach { idx, view in
            view.setType(type: data[idx].type.name)
            view.setValue(value: data[idx].value)
            view.tapAction = { [weak self] in self?.viewModel?.inputs.didTapRunData(index: idx) }
        }

        showRoutesOnMap(routes: viewModel.outputs.pathCoordinates, slices: viewModel.outputs.slices)

        endRunningButton.didTapButtonSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.view.notificationFeedback()
                self?.viewModel?.inputs.didLongHoldStopRunningButton()
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycles

extension PausedRunningViewController {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
}

// MARK: - Actions

extension PausedRunningViewController {
    @objc
    func didTapResumeButton() {
        viewModel?.inputs.didTapResumeButton()
        view.notificationFeedback()
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
        view.backgroundColor = UIColor(named: "accent")
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel?.inputs.closeAnimationEnded()
        }
    }
}

// MARK: - MKMapViewDelegate Implementation

extension PausedRunningViewController: MKMapViewDelegate {
    func showRoutesOnMap(routes: [CLLocationCoordinate2D], slices: [RunningSlice]) {
        if routes.isEmpty { return }
        slices.forEach {
            print("DRAWSlice \($0.startIndex) - \($0.endIndex) (\($0.isRunning))")
        }

        slices.forEach { slice in
            if routes.isEmpty { return }
            var endIdx = slice.endIndex
            if slice.endIndex < 0 || slice.endIndex > routes.count - 1 {
                endIdx = routes.count - 1
            }
            color = [UIColor.systemBlue, .systemRed][slice.isRunning ? 0 : 1].withAlphaComponent(0.9)
            mapView.addOverlay(MKPolyline(
                coordinates: Array(routes[slice.startIndex ... endIdx]),
                count: endIdx - slice.startIndex + 1
            ))
        }
    }

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = color
            renderer.lineWidth = 7
            return renderer
        }

        return MKOverlayRenderer()
    }
}

// MARK: - Configure

extension PausedRunningViewController {
    // swiftlint:disable:next function_body_length
    func configureLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewHeightConstraint,
        ])

        runDataViews.forEach { $0.valueLabel.textColor = .label }
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

    private func makeRunDataStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = .standard
        view.isUserInteractionEnabled = false
        view.delegate = self
        view.region = MKCoordinateRegion(
            center: view.userLocation.coordinate,
            span: view.region.span
        )
        view.userTrackingMode = .follow
        return view
    }

    private func makeResumeButton() -> UIButton {
        let button = CircleButton(with: .resume)
        button.addTarget(self, action: #selector(didTapResumeButton), for: .touchUpInside)
        return button
    }
}
