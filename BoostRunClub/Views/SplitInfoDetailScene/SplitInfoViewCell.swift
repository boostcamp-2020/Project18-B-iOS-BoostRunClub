//
//  SplitInfoViewCell.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import UIKit

protocol SplitInfoViewModelType: CellViewModelTypeBase {
    var type: String { get }
    var value: String { get }
}

struct SplitInfoElement: SplitInfoViewModelType, Hashable {
    let identifier = UUID()
    let type: String
    let value: String
}

struct SpliInfo {
    let list: [SplitInfoElement]

    init() {
        list = [
            SplitInfoElement(type: "Distance", value: "5.00KM"),
            SplitInfoElement(type: "Avg. Pace", value: "16'48\"/km"),
            SplitInfoElement(type: "Distance", value: "5.00KM"),
        ]
    }
}

class SplitInfoViewCell: UICollectionViewListCell, CellConfigurable {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    private let fontSize: CGFloat = 17
    private let inset: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup(viewModel: CellViewModelTypeBase) {
        guard let viewModel = viewModel as? SplitInfoViewModelType else { return }

        titleLabel.text = viewModel.type
        valueLabel.text = viewModel.value
    }

    func commonInit() {
        let stackView = UIStackView.make(with: [titleLabel, valueLabel], distribution: .fillEqually)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            separatorLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

extension UILabel {
    func setTextAlignment(idx: Int, total: Int) {
        textAlignment = [.left, .center, .right][idx == 0 ? 0 : 1 + (idx + 1) / total]
    }
}
