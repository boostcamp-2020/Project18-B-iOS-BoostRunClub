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

    private var tabHeight: CGFloat = 0
    private var rows = [[String]]()

    var viewModel: ActivityDateFilterViewModelTypes?
    var cancellables = Set<AnyCancellable>()

    init(with viewModel: ActivityDateFilterViewModelTypes, tabHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.tabHeight = tabHeight
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.outputs.pickerListSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.rows = $0
                self?.sheetView.pickerView.reloadAllComponents()
            }
            .store(in: &cancellables)

        viewModel.outputs.adjustPickerSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.sheetView.pickerView.selectRow($0.row, inComponent: $0.component, animated: $0.animate)
            }
            .store(in: &cancellables)

        // Inputs
        sheetView.didTapSelect = { [weak viewModel] in
            viewModel?.inputs.didTapSelectButton()
        }
    }

    deinit {
        print("[Memory \(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
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
        viewModel?.inputs.viewDidLoad()
        sheetViewBottomHeightConstraint.constant = sheetView.contentSize.height
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            },
            completion: { _ in
                self.dismiss(animated: false, completion: nil)
            }
        )
    }
}

// MARK: - UIPickerViewDatasource Implementation

extension ActivityDateFilterViewController: UIPickerViewDataSource {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rows[component][row]
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return rows.count
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows[component].count
    }
}

// MARK: - UIPickerViewDelegate Implementation

extension ActivityDateFilterViewController: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.inputs.didPickerChanged(row: row, component: component)
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
