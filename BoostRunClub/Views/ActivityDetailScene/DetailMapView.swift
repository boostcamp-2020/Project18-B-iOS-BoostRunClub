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

    func configure(locations: [Location], splits _: [RunningSplit]) {
        let coords = locations.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let region = MKCoordinateRegion.make(from: coords, offsetRatio: 0.3)
        mapView.setRegion(region, animated: false)
        mapView.addOverlay(
            PaceGradientRouteOverlay(
                locations: locations,
                mapRect: mapView.visibleMapRect,
                colorMin: .red,
                colorMax: .green
            ))

        CLLocationCoordinate2D.computeSplitCoordinate(from: coords, distance: 1000)
            .enumerated()
            .forEach { index, splitCoordinate in
                let split = MKPointAnnotation()
                split.title = "\(index + 1)km"
                split.coordinate = splitCoordinate
                self.mapView.addAnnotation(split)
            }
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
