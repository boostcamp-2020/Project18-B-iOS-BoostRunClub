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
    private lazy var stopRunningButton: UIButton = makeResumeButton()

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
    }

    func bindViewModel() {}

    func configureLayout() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
        ])

        view.addSubview(resumeButton)
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resumeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            resumeButton.heightAnchor.constraint(equalToConstant: 100),
            resumeButton.widthAnchor.constraint(equalTo: resumeButton.heightAnchor, multiplier: 1),
        ])

        view.addSubview(stopRunningButton)
        stopRunningButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopRunningButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            stopRunningButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            stopRunningButton.heightAnchor.constraint(equalToConstant: 100),
            stopRunningButton.widthAnchor.constraint(equalTo: stopRunningButton.heightAnchor, multiplier: 1),
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
    func didTapStopRunningButton() {
        viewModel?.inputs.didTapStopRunningButton()
    }
}

// MARK: - Configure

extension PausedRunningViewController {
    private func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = true
        view.mapType = MKMapType.standard
        view.userTrackingMode = MKUserTrackingMode.follow
        view.isUserInteractionEnabled = false
        return view
    }

    private func makeResumeButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .orange
//        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = CGFloat(50)
        button.addTarget(self, action: #selector(didTapResumeButton), for: .touchUpInside)
        return button
    }

    private func makeEndRunningButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .black
//        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = CGFloat(50)
        button.addTarget(self, action: #selector(didTapStopRunningButton), for: .touchUpInside)
        return button
    }
}
