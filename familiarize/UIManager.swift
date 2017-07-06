//
//  UIManager.swift
//  familiarize
//
//  Created by Alex Oh on 6/12/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

class UIManager {
    static func makeButton(imageName: String = "") -> UIButton {
        let image = UIImage(named: imageName) as UIImage?
        let button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }

    static func makeImage(imageName: String = "") -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        //imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    static func makeLabel(numberOfLines: Int = 1) -> UILabel {
        let label =  UILabel()
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        return label
    }
    
    static func makeProfileImage(valueOfCornerRadius cr: CGFloat) -> UIImageView {
        let image = UIManager.makeImage(imageName: "blank_man")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = cr
        image.layer.masksToBounds = true
        return image
    }
}
