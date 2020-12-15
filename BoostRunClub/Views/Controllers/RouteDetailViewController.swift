//
//  RouteDetailViewController.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/13.
//

import Combine
import MapKit
import UIKit

final class RouteDetailViewController: UIViewController {
    private var mapView = MKMapView()
    private lazy var closeButton: UIButton = makeCloseButton()

    private var viewModel: RouteDetailViewModelTypes?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: RouteDetailViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.detailConfigSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] (detail: ActivityDetailConfig) in
                self?.setupMapView(detail)
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[\(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycle

extension RouteDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = .systemBackground
        configureLayout()
        bindViewModel()
        viewModel?.inputs.viewDidLoad()
    }
}

// MARK: - Action

extension RouteDetailViewController {
    @objc
    func closeRouteDetailView() {
        viewModel?.inputs.didTapCloseButton()
    }
}

// MARK: - Make Views

extension RouteDetailViewController {
    private func makeCloseButton() -> UIButton {
        let button = UIButton()
        button.setSFSymbol(iconName: "xmark",
                           size: 17.5,
                           weight: .semibold,
                           tintColor: .systemBackground,
                           backgroundColor: .label)
        button.bounds.size = CGSize(width: 32, height: 32)
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(closeRouteDetailView), for: .touchUpInside)
        return button
    }
}

// MARK: - Configure

extension RouteDetailViewController {
    private func configureLayout() {
        // MARK: MapView AutoLayout

        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // MARK: CloseButton AutoLayout

        mapView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
        ])
    }
}

// MARK: - MKMapViewDelegate

extension RouteDetailViewController: MKMapViewDelegate {
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let routeOverlay = overlay as? PaceGradientRouteOverlay
        else { return MKOverlayRenderer() }
        let renderer = GradientRouteRenderer(overlay: routeOverlay)
        renderer.lineWidth = 10

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        if let distanceLabelText = annotation.title {
            let customAnnotation = UIImage.customSplitAnnotation(type: .split, title: distanceLabelText ?? "")
            annotationView!.image = customAnnotation
        }

        return annotationView
    }
}

// MARK: - Private methods

extension RouteDetailViewController {
    private func setupMapView(_ detail: ActivityDetailConfig) {
        let coordinates: [CLLocationCoordinate2D] = detail.locations
            .map { (location: Location) in
                CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
        let region = MKCoordinateRegion.make(from: coordinates, offsetRatio: 0.3)

        mapView.setRegion(region, animated: false)
        mapView.addOverlay(
            PaceGradientRouteOverlay(
                locations: detail.locations,
                mapRect: mapView.visibleMapRect,
                colorMin: .red,
                colorMax: .green
            ))

        CLLocationCoordinate2D.computeSplitCoordinate(from: coordinates, distance: 1000)
            .enumerated()
            .forEach { index, splitCoordinate in
                let split = MKPointAnnotation()
                split.title = "\(index + 1)km"
                split.coordinate = splitCoordinate
                self.mapView.addAnnotation(split)
            }
    }
}
