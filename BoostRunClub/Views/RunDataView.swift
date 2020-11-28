//
//  RunDataView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/28.
//

import UIKit

class RunDataView: UIStackView {
    
    enum Style {
        case main, sub
    }
    
    let style: Style
    
    private lazy var valueLabel: UILabel = {
        let label: UILabel
        switch style {
        case .main:
            label = NikeLabel()
        case .sub:
            label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    init(with labelType: Style = .sub) {
        self.style = labelType
        super.init(frame: .zero)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        self.style = .sub
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        distribution = .equalSpacing
        alignment = .center
        
        switch style {
        case .main:
            valueLabel.font = valueLabel.font.withSize(50)
            descriptionLabel.font = descriptionLabel.font.withSize(20)
        case .sub:
            valueLabel.font = valueLabel.font.withSize(25)
            descriptionLabel.font = descriptionLabel.font.withSize(20)
        }
        
        addArrangedSubview(valueLabel)
        addArrangedSubview(descriptionLabel)
    }
    
    
}

