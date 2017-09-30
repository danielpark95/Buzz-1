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
    
    static func makeTextButton(buttonText: String, color: UIColor = .black) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(color, for: .normal)
        return button
    }
    
    static func makeImage(imageName: String = "") -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }
    
    static func makeLabel(numberOfLines: Int = 1, withText text: String = " ") -> UILabel {
        let label =  UILabel()
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
    
    static func makeProfileImage(valueOfCornerRadius cr: CGFloat) -> UIImageView {
        let image = UIManager.makeImage(imageName: "")
        image.contentMode = .scaleAspectFit
        // Creates a corner radius around the image but doesnt not crop the picture yet.
        image.layer.cornerRadius = cr
        // Crops the image according to the corner radius size.
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0
        image.layer.borderColor = UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0).cgColor
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }
    
    static func makeCardProfileImageData(_ imageData: Data) -> Data {
        var image = UIImage(data: imageData)
        image = image?.roundImage()
        return UIImagePNGRepresentation(image!)!
    }
    
    static func makeRegularHandForDisplay(_ longSocialMediaName: String) -> String? {
        let shortHandForQR = [
            "name": "Name",
            "bio": "Bio",
            "phoneNumber": "PHONE",
            "email": "EMAIL",
            "faceBookProfile": "FACEBOOK",
            "instagramProfile": "INSTAGRAM",
            "snapChatProfile": "SNAPCHAT" ,
            "twitterProfile": "TWITTER",
            "linkedInProfile": "LINKEDIN",
            "soundCloudProfile": "SOUNDCLOUD",
            "venmoProfile": "VENMO",
            "slackProfile": "SLACK",
            "gitHubProfile": "GITHUB",
            "spotifyProfile": "SPOTIFY",
            "kakaoTalkProfile": "KAKAOTALK",
            "whatsAppProfile": "WHATSAPP",
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
    
    private static func cropRightImage(image: UIImage, withImageXCoordPadding imageXCoordPadding: CGFloat) -> UIImage {
        let rect = CGRect(x: imageXCoordPadding, y: 0, width: image.size.width, height: image.size.height)
        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
}

extension UIImage
{
    func roundImage() -> UIImage
    {
        let newImage = self.copy() as! UIImage
        let cornerRadius = self.size.height/2
        
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0)
        let bounds = CGRect(origin: CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        newImage.draw(in: bounds)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
}

