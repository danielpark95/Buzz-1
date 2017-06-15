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
        return button
    }

    static func makeImage(imageName: String = "") -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func makeLabel(numberOfLines: Int = 1) -> UILabel {
        let label =  UILabel()
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
