//
//  UserCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import QRCode
import SwiftyJSON
import UIKit



class UserCell: UICollectionViewCell {
    
    var fullBrightness: Bool = false
    
    // Padding for moving the user profile picture around
    // The amount of padding removes X amount of padding from the right side.
    // We have to compensate for the lost padding in the view controller by removing the width of the image when applying constraints
    let imageXCoordPadding: CGFloat = -230
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(manageBrightness), name: .UIScreenBrightnessDidChange, object: nil)
    }
    
    func manageBrightness() {
        if (self.fullBrightness == true) {
            //UIScreen.main.brightness = 1.0
        } else {
            //let delegate = UIApplication.shared.delegate as! AppDelegate
            //UIScreen.main.brightness = delegate.userBrightnessLevel
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onQRImage: Bool = true
    var qrImageView: UIImageView?
    
    var myUserProfile: UserProfile? {
        didSet {
            
            let name = NSMutableAttributedString(string: (myUserProfile?.name)!, attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 25)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
            nameLabel.attributedText = name
            
            let bio = NSMutableAttributedString(string: (myUserProfile?.bio)!, attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 18)!, NSForegroundColorAttributeName: UIColor(red:144/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1.0)])
            bioLabel.attributedText = bio
            
            //self.profileImage.image = UIImage(data: (self.myUserProfile?.profileImage)!)
            
            //profileImage = UIManager.makeCardProfileImage((myUserProfile?.profileImage)!, withImageXCoordPadding: imageXCoordPadding)
            
            // When myUserProfile is set within the UserController as a cell, then load up the required information that the user has.
            createQR(myUserProfile!)
            setupViews()
        }
    }
    
    func createJSON(_ profile: UserProfile) -> String {
        var jsonDict: [String: String] = [:]
        for key in (profile.entity.attributesByName.keys) {
            if (profile.value(forKey: key) != nil && UIManager.makeShortHandForQR(key) != nil) {
                    jsonDict[key] = profile.value(forKey: key) as? String
            }
        }
        return JSON(jsonDict).rawString()!
    }

    func createQR(_ profile: UserProfile) {
        var qrCode = QRCode(self.createJSON(profile))
        qrCode?.color = CIColor.white()
        qrCode?.backgroundColor = CIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        qrImageView = UIManager.makeImage()
        qrImageView?.image = qrCode?.image
    }
    
    var profileImage: UIImageView = {
        let image = UIManager.makeImage()
        image.clipsToBounds = true
        image.contentMode = UIViewContentMode.scaleAspectFill
        return image
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
    }()
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    
    func flipCard() {
        for v in (self.subviews){
            v.removeFromSuperview()
        }
        
        if onQRImage == true {
            presentProfile()
        } else {
            presentScannableCode()
        }
    }
    
    func presentScannableCode() {
        addSubview(qrImageView!)
        qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        qrImageView?.heightAnchor.constraint(equalToConstant: 300).isActive = true
        qrImageView?.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    func presentProfile() {
        addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 41).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -160).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 350).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 350 + (imageXCoordPadding/4)).isActive = true
        // We have to do imageXCoordPadding/4 because we are removing some pieces on the right side and have to compensate for it.
        
        //Namelabel position upated using NSLayoutConstraint -dan
        addSubview(nameLabel)
        addSubview(bioLabel)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 290).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 350).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        presentSocialMediaButtons()
    }
    
    func setupViews() {
        flipCard()
    }

    lazy var socialMediaImages: [String: UIImageView] = [
        "phoneNumber": UIManager.makeImage(imageName: "dan_phone_black"),
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebook_black"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagram_black"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapchat_black"),
        "linkedInProfile": UIManager.makeImage(imageName: "dan_linkedin_black"),
        "email": UIManager.makeImage(imageName: "dan_email_black"),
        "twitterProfile": UIManager.makeImage(imageName: "dan_twitter_black"),
        "soundCloudProfile": UIManager.makeImage(imageName: "dan_soundcloud_black"),
        ]
    
    //Helper function to space out social media icons - dan
    func autoSpaceButtons(r: Double, theta1: Double, theta2: Double, imagesToPresent: [UIImageView]){
        var count = 0
        for image in imagesToPresent{
            self.addSubview(image)
            image.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor, constant: CGFloat(r * cos(theta1 + Double(count) * theta2) + 30)).isActive = true
            image.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: CGFloat(r * sin(theta1 + Double(count) * theta2))).isActive = true
            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
            image.widthAnchor.constraint(equalToConstant: 50).isActive = true
            count += 1
        }
    }
    
    //Function to space out social media icons evenly around the profile picture at an equal distance -dan
    func presentSocialMediaButtons() {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        let size = my_imagesToPresent.count
        var my_theta1 = 0.0
        var my_theta2 = 0.0
        let rad = 57.2958
        if size == 1 {
            
        } else if size == 2 {
            my_theta1 = 110.0
            my_theta2 = 35.0
        } else if size == 3 {
            my_theta1 = 110.0
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
        
        autoSpaceButtons(r: 220.0, theta1: my_theta1 / rad, theta2: my_theta2 / rad, imagesToPresent: my_imagesToPresent)
    }
}
