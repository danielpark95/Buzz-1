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
        image.contentMode = .scaleAspectFit
        // Creates a corner radius around the image but doesnt not crop the picture yet.
        image.layer.cornerRadius = cr
        // Crops the image according to the corner radius size.
        image.layer.masksToBounds = true
        return image
    }
    
    static func makeCardProfileImageData(_ imageData: Data, withImageXCoordPadding imageXCoordPadding: CGFloat) -> Data {
        var image = UIImage(data: imageData)
        image = image?.roundImage()
        
//        // Make all images uniform in size so that cropping is uniform.
        //UIGraphicsBeginImageContext(CGSize(width: 1400, height: 1400))
        //image?.draw(in: CGRect(x: 0, y: 0, width: 1400, height: 1400))
        //let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
//        
//        // Crop the right side of the image so that we can make the card on the top right of the screen.
        //image = cropRightImage(image: newImage!, withImageXCoordPadding: imageXCoordPadding)
        return UIImagePNGRepresentation(image!)!
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

