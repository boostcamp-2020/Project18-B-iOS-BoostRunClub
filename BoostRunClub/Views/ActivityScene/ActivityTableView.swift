//
//  ActivityTableView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import UIKit

class ActivityTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Configure

extension ActivityTableView {
    private func commonInit() {
        backgroundColor = UIColor(named: "tableBackground")
        estimatedRowHeight = 200
        allowsSelection = true
        alwaysBounceVertical = true
        isScrollEnabled = true
        sectionHeaderHeight = 5
        sectionFooterHeight = 5
        separatorInset.right = 20
        rowHeight = UITableView.automaticDimension
    }
}
