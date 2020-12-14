//
//  RunningMapViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Combine
import MapKit
import UIKit

class RunningMapViewController: UIViewController {
    private lazy var mapView: MKMapView = makeMapView()
    private lazy var locateButton: UIButton = makeLocateButton()

    private var viewModel: RunningMapViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: RunningMapViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.outputs.routesSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] routes in
                self?.mapView.addOverlay(MKPolyline(coordinates: routes, count: routes.count))
            }
            .store(in: &cancellables)

        viewModel.outputs.userTrackingModeOnWithAnimatedSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] animated in self?.mapView.setUserTrackingMode(.follow, animated: animated) }
            .store(in: &cancellables)

        viewModel.outputs.userTrackingModeOffSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.mapView.setUserTrackingMode(.none, animated: false) }
            .store(in: &cancellables)
    }

    deinit {
        print("[\(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycle

extension RunningMapViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.inputs.viewWillDisappear()
    }
}

// MARK: - Action

extension RunningMapViewController {
    @objc
    func didTapLocateButton() {
        viewModel?.inputs.didTapLocateButton()
    }
}

// MARK: - MKMapViewDelegate

extension RunningMapViewController: MKMapViewDelegate {
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let routePolyline = overlay as? MKPolyline
        else { return MKOverlayRenderer() }

        let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 7

        return renderer
    }
}

// MARK: - Configure

extension RunningMapViewController {
    func configureLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.addSubview(locateButton)
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            locateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            locateButton.heightAnchor.constraint(equalToConstant: 60),
            locateButton.widthAnchor.constraint(equalTo: locateButton.heightAnchor, multiplier: 1),
        ])
    }

    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.delegate = self
        view.showsUserLocation = true
        view.mapType = .standard
        view.userTrackingMode = .follow
        view.region = MKCoordinateRegion(
            center: view.userLocation.coordinate,
            span: view.region.span
        )

        return view
    }

    private func makeLocateButton() -> UIButton {
        let button = CircleButton(with: .locate)
        button.addTarget(self, action: #selector(didTapLocateButton), for: .touchUpInside)
        return button
    }
}
