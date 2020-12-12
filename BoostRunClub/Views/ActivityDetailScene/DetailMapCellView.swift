//
//  DetailMapCellView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import MapKit
import UIKit

class DetailMapCellView: UICollectionViewCell {
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

    func configure(with _: ActivityTotalConfig) {}

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

// MARK: - Actions

extension DetailMapCellView {
    @objc
    func didTapDetailRouteButton() {}
}

// MARK: - Configure

extension DetailMapCellView {
    private func commonInit() {
        configureLayout()
    }

    private func configureLayout() {
        let width = UIScreen.main.bounds.width - 40
        let height = UIScreen.main.bounds.height
        contentView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.heightAnchor.constraint(equalToConstant: height / 2),
            mapView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        contentView.addSubview(detailRouteButton)
        detailRouteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailRouteButton.heightAnchor.constraint(equalToConstant: 60),
            detailRouteButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            detailRouteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailRouteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailRouteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
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
