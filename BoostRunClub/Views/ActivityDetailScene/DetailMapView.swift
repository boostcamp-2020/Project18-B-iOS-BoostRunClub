//
//  DetailMapView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import CoreLocation.CLLocation
import MapKit
import UIKit

class DetailMapView: UIView {
    private lazy var mapView = makeMapView()
    private lazy var detailRouteButton = makeDetailRouteButton()

    private(set) var didTapShowDetailMapSignal = PassthroughSubject<Void, Never>()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(locations: [Location], splits: [RunningSplit]) {
        let coords = locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let region = MKCoordinateRegion.make(from: coords, offsetRatio: 0.3)
        mapView.setRegion(region, animated: false)
        mapView.addOverlay(
            PaceGradientRouteOverlay(
                locations: locations,
                splits: splits,
                mapRect: mapView.visibleMapRect,
                colorMin: .red,
                colorMax: .green
            ))

        splits.enumerated()
            .forEach { index, split in
                guard
                    index < splits.count - 1,
                    let lastSlice = split.runningSlices.last,
                    lastSlice.endIndex > 0
                else { return }

                let annotation = MKPointAnnotation()
                annotation.title = "\(index + 1)km"
                let locationIdx = lastSlice.endIndex < coords.count ? lastSlice.endIndex : coords.count - 1
                annotation.coordinate = coords[locationIdx]
                self.addAnnotation(in: mapView, coordinate: coords[locationIdx], title: "\(index + 1)km")
            }
    }

    private func makeCustomAnnotationView(in mapView: MKMapView, for annotation: MKAnnotation) -> CustomAnnotationView {
        let identifier = "CustomAnnotationViewID"

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let customAnnotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            return customAnnotationView
        }
    }

    private func makeCustomAnnotationImage(with annotation: MKAnnotation) -> UIImage {
        if let distanceLabelText = annotation.title {
            return UIImage.customSplitAnnotation(type: .split, title: distanceLabelText ?? "")
        } else {
            return UIImage.customSplitAnnotation(type: .split, title: "")
        }
    }

    private func addAnnotation(in _: MKMapView, coordinate: CLLocationCoordinate2D, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

// MARK: - Actions

extension DetailMapView {
    @objc
    func didTapDetailRouteButton() {
        didTapShowDetailMapSignal.send()
    }

    @objc
    func didTapMap() {
        didTapShowDetailMapSignal.send()
    }
}

// MARK: - MKMapViewDelegate

extension DetailMapView: MKMapViewDelegate {
    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let routeOverlay = overlay as? PaceGradientRouteOverlay
        else { return MKOverlayRenderer() }
        let renderer = GradientRouteRenderer(overlay: routeOverlay)
        renderer.lineWidth = 10

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let customAnnotationView = makeCustomAnnotationView(in: mapView, for: annotation)
        customAnnotationView.image = makeCustomAnnotationImage(with: annotation)
        return customAnnotationView
    }
}

// MARK: - Private methods

// MARK: - Configure

extension DetailMapView {
    private func commonInit() {
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMap)))
        configureLayout()
    }

    private func configureLayout() {
        let height = UIScreen.main.bounds.height

        mapView.translatesAutoresizingMaskIntoConstraints = false
        detailRouteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: height / 2),
            detailRouteButton.heightAnchor.constraint(equalToConstant: 60),
        ])

        let vStack = UIStackView.make(
            with: [mapView, detailRouteButton],
            axis: .vertical, alignment: .fill, distribution: .equalSpacing, spacing: 20
        )
        addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.isScrollEnabled = false
        view.isZoomEnabled = false
        view.layer.cornerRadius = 10
        return view
    }

    private func makeDetailRouteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("경로 상세", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapDetailRouteButton), for: .touchUpInside)
        return button
    }
}
