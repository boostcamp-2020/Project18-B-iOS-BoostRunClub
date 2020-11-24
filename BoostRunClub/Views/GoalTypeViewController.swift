//
//  GoalTypeViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/23.
//

import Combine
import UIKit

class GoalTypeViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 1
        tableView.allowsSelection = true
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.register(GoalTypeCell.self, forCellReuseIdentifier: String(describing: GoalTypeCell.self))
        tableView.separatorInset.left = 20
        tableView.separatorInset.right = 20
        tableView.layer.cornerRadius = 30
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: verticalTablePadding))
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: verticalTablePadding * 2))
        let clearButton = UIButton()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("지우기", for: .normal)
        clearButton.setTitleColor(.label, for: .normal)
        footer.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            clearButton.topAnchor.constraint(equalTo: footer.topAnchor, constant: 0),
            clearButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        return tableView
    }()

    let bounds = UIScreen.main.bounds
    var viewModel: GoalTypeViewModelTypes?
    var cancellables: Set<AnyCancellable> = []
    lazy var tableViewHeight = CGFloat(viewModel?.output.numberOfCell ?? 0) * GoalTypeCell.cellHeight + verticalTablePadding * 3
    let verticalTablePadding: CGFloat = 30

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(with goalTypeViewModel: GoalTypeViewModelTypes) {
        super.init(nibName: nil, bundle: nil)
        viewModel = goalTypeViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let size = CGSize(width: bounds.width,
                          height: tableViewHeight)
        let origin = CGPoint(x: 0, y: bounds.height)

        tableView.frame = CGRect(origin: origin, size: size)

//        tableView.translatesAutoresizingMaskIntoConstraints = false

        var gesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ////            tableView.heightAnchor.constraint(equalToConstant: 400)
//        ])

        bindViewModel()
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.output.goalTypeSubject.sink {
            print($0)
        }

        viewModel.output.closeSheet
            .receive(on: RunLoop.main)
            .sink { self.closeWithAnimation() }
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.bounds.origin.y = -tableView.bounds.height
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            [weak self] in
            guard let self = self else { return }
            self.tableView.frame.origin.y = self.bounds.height - self.tableViewHeight
            self.tableView.bounds.origin.y = 0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: nil)
    }
}

// MARK: - Actions

extension GoalTypeViewController {
    @objc
    func didTapBackgroundView(gesture: UITapGestureRecognizer) {
        if !tableView.point(inside: gesture.location(in: tableView), with: nil) {
            viewModel?.input.didTapBackgroundView()
        } else {}
    }

    func closeWithAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            [weak self] in
            guard let self = self else { return }
            self.tableView.frame.origin.y = self.bounds.height
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in

            self.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: - Delegate

extension GoalTypeViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.input.didSelectCell(at: indexPath.row)
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        100
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        100
    }
}

// MARK: - DataSource

extension GoalTypeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.output.numberOfCell ?? 0
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let goalType = viewModel?.output.cellForRowAt(index: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GoalTypeCell.self)) as? GoalTypeCell
        else { return UITableViewCell() }

        cell.goalTypeLabel.text = goalType.name

        return cell
    }
}
