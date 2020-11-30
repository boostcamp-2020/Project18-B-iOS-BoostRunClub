//
//  RunningViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import UIKit

class RunningInfoViewController: UIViewController {
    private var viewModel: RunningInfoViewModelTypes?

    private var subRunDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private var mainRunDataView = RunDataView(style: .main)

    private var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .black
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = CGFloat(50)
        button.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
        return button
    }()

    init(with runningViewModel: RunningInfoViewModelTypes?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = runningViewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.9763557315, green: 0.9324046969, blue: 0, alpha: 1)

        subRunDataStackView.addArrangedSubview(RunDataView())
        subRunDataStackView.addArrangedSubview(RunDataView())
        subRunDataStackView.addArrangedSubview(RunDataView())

        subRunDataStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subRunDataStackView)

        NSLayoutConstraint.activate([
            subRunDataStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            subRunDataStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subRunDataStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])

        mainRunDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainRunDataView)

        NSLayoutConstraint.activate([
            mainRunDataView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            mainRunDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)

        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.heightAnchor.constraint(equalToConstant: 100),
            pauseButton.widthAnchor.constraint(equalTo: pauseButton.heightAnchor, multiplier: 1),
        ])
    }

    @objc
    func didTapPauseButton() {}
}
