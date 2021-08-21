//
//  UIImage+SFSymbol.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/03.
//

import UIKit

extension UIImage {
    static func SFSymbol(
        name: String,
        size: CGFloat,
        weight: UIImage.SymbolWeight,
        scale: UIImage.SymbolScale,
        color: UIColor = .label,
        renderingMode: UIImage.RenderingMode = .automatic
    ) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: size,
                                                        weight: weight,
                                                        scale: scale)
        return UIImage.SFSymbol(name: name,
                                configuration: configuration,
                                color: color,
                                renderingMode: renderingMode)
    }

    static func SFSymbol(
        name: String,
        configuration: UIImage.SymbolConfiguration? = nil,
        color: UIColor = .label,
        renderingMode: UIImage.RenderingMode = .alwaysOriginal
    ) -> UIImage? {
        if let configuration = configuration {
            return UIImage(systemName: name, withConfiguration: configuration)?
                .withTintColor(color, renderingMode: renderingMode)
        } else {
            return UIImage(systemName: name)?.withTintColor(color, renderingMode: renderingMode)
        }
    }
}
