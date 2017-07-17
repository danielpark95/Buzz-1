//
//  UIManager.swift
//  familiarize
//
//  Created by Alex Oh on 6/12/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

class UIButtonWithIndexPath: UIButton {
    var indexPathItem: Int?
}

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
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    static func makeShortHandForQR(_ longSocialMediaName: String) -> String? {
        let shortHandForQR = [
            "name": "name",
            "bio": "bio",
            "email": "em",
            "phoneNumber": "pn",
            "faceBookProfile": "fb",
            "snapChatProfile": "sc" ,
            "instagramProfile": "ig",
            "linkedInProfile": "in",
            "soundCloudProfile": "so",
            "twitterProfile": "tw",
            ]
        if let shortName = shortHandForQR[longSocialMediaName] {
            return shortName
        } else {
            return nil
        }
    }
    
    static func makeRegularHandForDisplay(_ longSocialMediaName: String) -> String? {
        let shortHandForQR = [
            "name": "Name",
            "bio": "Bio",
            "email": "Email",
            "phoneNumber": "Phone Number",
            "faceBookProfile": "Facebook",
            "snapChatProfile": "Snapchat" ,
            "instagramProfile": "Instagram",
            "linkedInProfile": "LinkedIn",
            "soundCloudProfile": "Soundcloud",
            "twitterProfile": "Twitter",
            ]
        if let shortName = shortHandForQR[longSocialMediaName] {
            return shortName
        } else {
            return nil
        }
    }
    
    static func makeDeleteButton(_ indexPathItem: Int) -> UIButtonWithIndexPath {
        let button = UIButtonWithIndexPath(frame: CGRect(x: 0, y: 20, width: 40, height: 40))
        button.setImage(UIImage(named: "dan_camera_91"), for: .normal)
        button.indexPathItem = indexPathItem
        return button
    }
    
}
