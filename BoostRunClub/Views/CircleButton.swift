//
//  CircleButton.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/02.
//

import UIKit

class CircleButton: UIButton {
    enum Style {
        case start, stop, pause, resume, locate, exit
    }

    init(with buttonStyle: Style) {
        super.init(frame: .zero)
        commonInit(with: buttonStyle)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(with buttonStyle: Style = .start) {
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        imageView?.contentMode = .scaleAspectFill

        switch buttonStyle {
        case .start:
            backgroundColor = UIColor(named: "accent")
            setTitle("시작", for: .normal)
            setTitleColor(UIColor(named: "accent2"), for: .normal)
        case .stop:
            setSFSymbol(iconName: "stop.fill", size: 25, tintColor: .systemBackground, backgroundColor: .label)
        case .pause:
            setSFSymbol(iconName: "pause.fill", size: 25, tintColor: .systemBackground, backgroundColor: .label)
            setTitleColor(UIColor(named: "accent2"), for: .normal)
        case .resume:
            setSFSymbol(iconName: "play.fill",
                        size: 25,
                        tintColor: .label,
                        backgroundColor: UIColor(named: "brcYellow")!)
        case .locate:
            setSFSymbol(iconName: "location.fill", size: 25, tintColor: .systemBackground, backgroundColor: .label)
        case .exit:
            setSFSymbol(iconName: "xmark", size: 25, tintColor: .systemBackground, backgroundColor: .label)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
