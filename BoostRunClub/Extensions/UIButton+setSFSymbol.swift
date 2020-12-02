//
//  UIButton+setSFSymbol.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/02.
//

import UIKit

extension UIButton {
    func setSFSymbol(iconName: String, size: CGFloat, weight: UIImage.SymbolWeight = .regular,
                     scale: UIImage.SymbolScale = .default, tintColor: UIColor, backgroundColor: UIColor)
    {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        let buttonImage = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        setImage(buttonImage, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
}
