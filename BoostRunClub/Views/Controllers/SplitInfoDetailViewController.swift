//
//  SplitInfoDetailViewController.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/13.
//

import Combine
import UIKit

class SplitInfoDetailViewController: UIViewController {
    var statusBarView: UIView?
    var dateInfoView = SplitDetailDateInfoView()
    var lowerViewHeader = SplitDetailSplitHeaderView()
    lazy var upperView = makeUpperTableView()
    lazy var lowerView = makeLowerTableView()

    let infoDataSource = SplitInfoDetailDataSource()
    let splitDataSource = SplitDatailSplitDataSource()

    var upperViewHeight: NSLayoutConstraint?
    var lowerViewHeight: NSLayoutConstraint?

    var viewModel: SplitInfoDetailViewModelType?
    var cancellables = Set<AnyCancellable>()

    init(with viewModel: SplitInfoDetailViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewModel() {
        viewModel?.outputs.dateSubject
            .sink { [weak self] in
                self?.dateInfoView.dateLabel.text = $0.date
                self?.dateInfoView.timeLabel.text = $0.time
            }
            .store(in: &cancellables)

        viewModel?.outputs.splitInfoSubject
            .sink { [weak self] in
                self?.infoDataSource.update($0)
                self?.upperView.reloadData()
            }
            .store(in: &cancellables)

        viewModel?.outputs.splitSubject
            .sink { [weak self] in
                self?.splitDataSource.update($0)
                self?.lowerView.reloadData()
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[\(Date())] 🍎ViewController🍏 \(Self.self) deallocated.")
    }
}

// MARK: - Life Cycles

extension SplitInfoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
    }

    override func updateViewConstraints() {
        upperViewHeight?.constant = upperView.contentSize.height
        lowerViewHeight?.constant = lowerView.contentSize.height
        super.updateViewConstraints()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusBarView?.removeFromSuperview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Configure Layout

extension SplitInfoDetailViewController {
    @objc
    func didTapBackButton() {
        // TODO: Coordinator로 연결?
        navigationController?.popViewController(animated: true)
    }
}

extension SplitInfoDetailViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Configure

extension SplitInfoDetailViewController {
    private func configureLayout() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])

        let stackView = UIStackView(arrangedSubviews: [dateInfoView, upperView, lowerViewHeader, lowerView])
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        configureArrangedViews(stackView: stackView)
    }

    private func configureArrangedViews(stackView: UIStackView) {
        dateInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateInfoView.centerXAnchor.constraint(equalTo: upperView.centerXAnchor),
            dateInfoView.widthAnchor.constraint(equalTo: upperView.widthAnchor),
            dateInfoView.heightAnchor.constraint(equalToConstant: 100),
        ])

        upperView.translatesAutoresizingMaskIntoConstraints = false
        upperViewHeight = upperView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            upperViewHeight!,
            upperView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])

        lowerViewHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lowerViewHeader.centerXAnchor.constraint(equalTo: lowerView.centerXAnchor),
            lowerViewHeader.widthAnchor.constraint(equalTo: lowerView.widthAnchor),
            lowerViewHeader.heightAnchor.constraint(equalToConstant: 100),
        ])

        lowerView.translatesAutoresizingMaskIntoConstraints = false
        lowerViewHeight = lowerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            lowerViewHeight!,
            lowerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

    private func configureNavigationBar() {
        statusBarView = navigationController?.setStatusBar(backgroundColor: .systemBackground)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationItem.hidesBackButton = true
        let backButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButtonItem.image = UIImage.SFSymbol(name: "chevron.left", color: .label)
        navigationItem.setLeftBarButton(backButtonItem, animated: true)
    }

    private func makeUpperTableView() -> UITableView {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = infoDataSource

        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame.size.height = 1
        tableView.register(SplitDetailInfoCell.self,
                           forCellReuseIdentifier: SplitDetailInfoCell.identifier)
        return tableView
    }

    private func makeLowerTableView() -> UITableView {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = splitDataSource
        tableView.separatorStyle = .none

        tableView.register(SplitDatailSplitCell.self,
                           forCellReuseIdentifier: SplitDatailSplitCell.identifier)
        return tableView
    }
}
