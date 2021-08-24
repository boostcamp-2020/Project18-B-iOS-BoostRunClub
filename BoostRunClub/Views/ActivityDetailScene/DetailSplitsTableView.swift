//
//  DetailSplitsTableView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Combine
import UIKit

class DetailSplitsTableView: UITableView {
    private(set) var didIntrinsicSizeChangedSignal = PassthroughSubject<CGSize, Never>()

    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
            didIntrinsicSizeChangedSignal.send(intrinsicContentSize)
        }
    }

    override var intrinsicContentSize: CGSize {
        contentSize
    }
}

// MARK: - Configure

extension DetailSplitsTableView {
    private func commonInit() {
        configureTableView()
    }

    private func configureTableView() {
        rowHeight = SimpleSplitViewCell.Constant.cellHeight
        allowsSelection = false
        alwaysBounceVertical = false
        isScrollEnabled = false
        separatorStyle = .none
        backgroundColor = .clear
        register(SimpleSplitViewCell.self, forCellReuseIdentifier: "\(SimpleSplitViewCell.self)")
    }
}
