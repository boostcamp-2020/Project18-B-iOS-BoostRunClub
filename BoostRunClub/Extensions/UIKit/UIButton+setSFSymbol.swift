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
        let buttonImage = UIImage.SFSymbol(
            name: iconName,
            size: size,
            weight: weight,
            scale: scale,
            color: tintColor
        )
        setImage(buttonImage, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
}
