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
    private lazy var sheetView = makeSheetView()
    private lazy var selectButton = makeSelectButton()
    private var pickerView = UIPickerView()
    private lazy var sheetViewBottomHeightConstraint = sheetView.heightAnchor.constraint(equalToConstant: 0)

    var tabHeight: CGFloat = 0

    let components: [String] = ["2020"]
    let pickerLists: [[String]] = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]]

    var viewModel: ActivityDateFilterViewModelTypes?

    init(with viewModel: ActivityDateFilterViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
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
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        configureLayout()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sheetViewBottomHeightConstraint.constant = 400
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

    @objc
    func didTapSelectButton() {}

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

extension ActivityDateFilterViewController: UIPickerViewDataSource {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerLists[component][row]
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return components.count
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
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -tabHeight),
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

    private func makeSheetView() -> UIScrollView {
        let scrollView = UIScrollView()
        let size = CGSize(width: UIScreen.main.bounds.width, height: 400)
        let origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        scrollView.contentSize = size
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false

        let view = UIView(frame: CGRect(origin: origin, size: size))
        view.backgroundColor = .systemBackground
        scrollView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            view.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            view.widthAnchor.constraint(equalToConstant: size.width),
            view.heightAnchor.constraint(equalToConstant: size.height),
        ])

        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])

        view.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            selectButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            selectButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            selectButton.heightAnchor.constraint(equalToConstant: 60),
        ])

        return scrollView
    }

    private func makeSelectButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .label
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        return button
    }
}
