//
//  ActivityDateFilterViewController.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Combine
import UIKit

class ActivityDateFilterViewController: UIViewController {
    private lazy var backgroundView = UIView()
    private lazy var sheetView = DateFilterSheetView(
        contentSize: CGSize(
            width: UIScreen.main.bounds.width,
            height: 400
        ))

    private lazy var sheetViewBottomHeightConstraint = sheetView.heightAnchor.constraint(equalToConstant: 0)

    var tabHeight: CGFloat = 0

    let pickerLists: [[String]] = [
        [
            "item1",
            "item2",
            "item3",
        ],
        [
            "item1",
            "item2",
            "item3",
        ],
    ]

    var viewModel: ActivityDateFilterViewModelTypes?

    init(with viewModel: ActivityDateFilterViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel

        print("\(DateFormatter.YMDHMFormatter.string(from: Date()))")
        print(" -> \(DateFormatter.YMDHMFormatter.string(from: Date().rangeOfYear!.from))")
        print(" ~ \(DateFormatter.YMDHMFormatter.string(from: Date().rangeOfYear!.to))")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        // Inputs
        sheetView.didTapSelect = { [weak viewModel] in
            viewModel?.inputs.didSelectDateFilter(selects: $0)
        }
    }

    deinit {
        print("\(Self.self) deinit")
    }
}

// MARK: - ViewController LifeCycle

extension ActivityDateFilterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        sheetView.pickerView.dataSource = self
        sheetView.pickerView.delegate = self
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        configureLayout()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sheetViewBottomHeightConstraint.constant = sheetView.contentSize.height
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            },
            completion: nil
        )
    }
}

// MARK: - Actions

extension ActivityDateFilterViewController {
    @objc
    func didTapBackgroundView(gesture: UITapGestureRecognizer) {
        if !view.point(inside: gesture.location(in: sheetView), with: nil) {
            viewModel?.inputs.didTapBackgroundView()
        }
    }

    func closeWithAnimation() {
        sheetViewBottomHeightConstraint.constant = 0
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            },
            completion: { _ in
                self.dismiss(animated: false, completion: nil)
            }
        )
    }
}

// MARK: - UIPickerViewDatasource Implementation

extension ActivityDateFilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLists[component][row]
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return pickerLists.count
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLists[component].count
    }
}

// MARK: - Configure

extension ActivityDateFilterViewController {
    private func configureLayout() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabHeight),
        ])

        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabHeight),
            sheetView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sheetView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            sheetViewBottomHeightConstraint,
        ])
    }
}
