//
//  DetailMapView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import CoreLocation.CLLocation
import MapKit
import UIKit

class DetailMapView: UIView {
    private lazy var mapView = makeMapView()
    private lazy var detailRouteButton = makeDetailRouteButton()

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
        mapView.addOverlay(MKPolyline(coordinates: coords, count: locations.count))
    }
}

// MARK: - Actions

extension DetailMapView {
    @objc
    func didTapDetailRouteButton() {}
}

// MARK: - MKMapViewDelegate

extension DetailMapView: MKMapViewDelegate {
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

extension DetailMapView {
    private func commonInit() {
        mapView.delegate = self
        configureLayout()
    }

    private func configureLayout() {
        let width = UIScreen.main.bounds.width - 40
        let height = UIScreen.main.bounds.height
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: height / 2),
            mapView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])

        addSubview(detailRouteButton)
        detailRouteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailRouteButton.heightAnchor.constraint(equalToConstant: 60),
            detailRouteButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            detailRouteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            detailRouteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            detailRouteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.isScrollEnabled = false
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
