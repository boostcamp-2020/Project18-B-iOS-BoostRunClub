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

        viewModel.outputs.regionSignal
            .receive(on: RunLoop.main)
            .sink { (region: MKCoordinateRegion) in
                self.mapView.setRegion(region, animated: false)
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
        button.setSFSymbol(iconName: "xmark", size: 17.5, weight: .semibold, tintColor: .white, backgroundColor: .label)
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
