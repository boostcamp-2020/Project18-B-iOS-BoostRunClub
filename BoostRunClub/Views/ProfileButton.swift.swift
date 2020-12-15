//
//  ProfileButton.swift.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/15.
//

import UIKit

extension UIBarButtonItem {
    static func makeProfileButton() -> UIBarButtonItem {
        var profileImage = UIImage()
        let button = UIButton(type: .custom)
        if let imageData = Data.loadImageDataFromDocumentsDirectory(fileName: "profile.png") {
            profileImage = UIImage(data: imageData) ?? UIImage()
        } else {
            profileImage = UIImage.SFSymbol(name: "person.circle",
                                            size: 27,
                                            weight: .regular,
                                            scale: .default,
                                            color: .systemGray,
                                            renderingMode: .automatic) ?? UIImage()
        }
        button.setImage(profileImage, for: .normal)
        button.tintColor = .systemGray
        button.imageView?.contentMode = .scaleAspectFill
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true

        let barButton = UIBarButtonItem(customView: button)

        barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButton.customView?.widthAnchor.constraint(equalToConstant: 35).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 35).isActive = true

        return barButton
    }
}
