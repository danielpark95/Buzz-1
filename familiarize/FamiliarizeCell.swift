//
//  FamiliarizeCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import QRCode
import SwiftyJSON
import UIKit

// You need to convert the JSON string to a data and then intialize it to create a json object! 


class FamiliarizeCell: UICollectionViewCell {

    
    var onQRImage: Bool = true
    var qrImageView: UIImageView?
    
    let shortHandForQR = [
        "bio": "bio",
        "faceBookProfile": "fb",
        "instagramProfile": "ig",
        "name": "name",
        "phoneNumber": "pn",
        "snapChatProfile": "sc" ,
        "linkedIn": "in",
        "email": "em",
        ]
    
    var myUserProfile: MyUserProfile? {
        didSet {
            // Views is set after knowing how long the texts are.
            
            // When myUserProfile is set within the UserController as a cell, then load up the required information that the user has.
            createQR(myUserProfile!)
            setupViews()
        }
    }
    
    func createJSON(_ profile: MyUserProfile) -> String {
        var jsonDict: [String: String] = [:]
        for key in (profile.entity.attributesByName.keys) {
            if (profile.value(forKey: key) != nil && shortHandForQR[key] != nil) {
                    jsonDict[shortHandForQR[key]!] = profile.value(forKey: key) as? String
            }
        }
        return JSON(jsonDict).rawString()!
    }
    
    func createQR(_ profile: MyUserProfile) {
        var qrCode = QRCode(self.createJSON(profile))
        qrCode?.color = CIColor.white()
        qrCode?.backgroundColor = CIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        qrImageView = UIManager.makeImage()
        qrImageView?.image = qrCode?.image
    }
    
    
    let profileImage: UIImageView = {
        //return UIManager.makeProfileImage(valueOfCornerRadius: 30)
        return UIManager.makeImage(imageName: "tjmiller6")
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
        
    }()
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    
    func flip() {
        for v in (self.subviews){
            v.removeFromSuperview()
        }
        
        if onQRImage == true {
            addSubview(profileImage)
            
            
            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -160).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            addSubview(nameLabel)
            addSubview(bioLabel)
            
            let name = NSMutableAttributedString(string: "T.J. Miller", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 25)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
            
            nameLabel.attributedText = name
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -103).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 150).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
            
            let bio = NSMutableAttributedString(string: "Miller the professional chiller.", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 18)!, NSForegroundColorAttributeName: UIColor(red:144/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1.0)])
            
            bioLabel.attributedText = bio
            bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -40).isActive = true
            bioLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 185).isActive = true
            bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
            bioLabel.widthAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.width).isActive = true
            
            presentSocialMediaButtons()
            
            onQRImage = false
        } else {
            addSubview(profileImage)
            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -160).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            addSubview(qrImageView!)
            qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 100).isActive = true
            qrImageView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            qrImageView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
            onQRImage = true
        }
    }
    
    func setupViews() {
        flip()
    }
    
    lazy var socialMediaImages: [String: UIImageView] = [
        "phoneNumber": UIManager.makeImage(imageName: "dan_phone_black"),
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebook_black"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagram_black"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapchat_black"),
        "linkedInProfile": UIManager.makeImage(imageName: "dan_linkedin_black"),
        "email": UIManager.makeImage(imageName: "dan_email_black"),
        ]
    
    func autoSpaceButtons(r: Double, theta1: Double, theta2: Double, imagesToPresent: [UIImageView]){
        var count = 0
        for image in imagesToPresent{
            self.addSubview(image)
            image.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor, constant: CGFloat(r * cos(theta1 + Double(count) * theta2))).isActive = true
            image.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: CGFloat(r * sin(theta1 + Double(count) * theta2))).isActive = true
            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
            image.widthAnchor.constraint(equalToConstant: 50).isActive = true
            count += 1
        }
    }
    
    func presentSocialMediaButtons() {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                print(key)
                my_imagesToPresent.append(socialMediaImages[key]!)
            }
        }
        var size = my_imagesToPresent.count
        size = 4
        var my_theta1 = 0.0
        var my_theta2 = 0.0
        let rad = 57.2958
        
        if size == 1 {
            
        } else if size == 2 {
            
        } else if size == 3 {
            print("size = 3")
            my_theta1 = 145.0
            my_theta2 = 35.0
        } else if size == 4 {
            //looks good
            my_theta1 = 110.0
            my_theta2 = 30.0
        } else if size == 5 {
            my_theta1 = 95.0
            my_theta2 = 25.0
        } else if size == 6 {
            //looks good
            my_theta1 = 80.0
            my_theta2 = 25.0
        } else {
            
        }
        autoSpaceButtons(r: 200.0, theta1: my_theta1 / rad, theta2: my_theta2 / rad, imagesToPresent: my_imagesToPresent)
    }
}
