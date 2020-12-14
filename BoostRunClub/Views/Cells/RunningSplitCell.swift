//
//  RunningSplitCell.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/09.
//

import Combine
import UIKit

extension UILabel {
    func applyChange(_ valueChange: ValueChange?) {
        guard let valueChange = valueChange else {
            text = ""
            return
        }
        let color: UIColor
        let prefix: String
        switch valueChange.status {
        case .decreased:
            color = .systemGreen
            prefix = "-"
        case .equal:
            color = .lightGray
            prefix = ""
        case .incresed:
            color = .systemRed
            prefix = "+"
        }

        textColor = color
        text = prefix + valueChange.value
    }
}

protocol CellConfigurable {
    func setup(viewModel: CellViewModelTypeBase)
}

class RunningSplitCell: UITableViewCell, CellConfigurable {
    let kilometerLabel = UILabel()
    let paceLabel = UILabel()
    let changeLabel = UILabel()

    var viewModel: RunningSplitCellViewModelType?
    var cancellables = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup(viewModel: CellViewModelTypeBase) {
        guard let viewModel = viewModel as? RunningSplitCellViewModelType else { return }
        self.viewModel = viewModel
        cancellables.removeAll()

        viewModel.kilometerSubject
            .sink { [weak self] in self?.kilometerLabel.text = $0 }
            .store(in: &cancellables)

        viewModel.paceSubject
            .sink { [weak self] in self?.paceLabel.text = $0 }
            .store(in: &cancellables)

        viewModel.changeSubject
            .sink { [weak self] in
                guard let valueChange = $0 else {
                    self?.changeLabel.text = nil
                    return
                }

                let color: UIColor
                let prefix: String
                switch valueChange.status {
                case .decreased:
                    color = .systemGreen
                    prefix = "-"
                case .equal:
                    color = .lightGray
                    prefix = ""
                case .incresed:
                    color = .systemRed
                    prefix = "+"
                }

                self?.changeLabel.textColor = color
                self?.changeLabel.text = prefix + valueChange.value
            }
            .store(in: &cancellables)
    }

    func commonInit() {
        let labels = [kilometerLabel, paceLabel, changeLabel]
        labels.enumerated().forEach { idx, label in
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = .lightGray
            label.setTextAlignment(idx: idx, total: labels.count)
        }

        let stackView = UIStackView.make(with: labels, distribution: .fillEqually, spacing: 20)
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -80),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
