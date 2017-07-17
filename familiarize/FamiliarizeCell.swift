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

class FamiliarizeCell: UICollectionViewCell {
    
    var fullBrightness: Bool = false
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
    
    enum borderTag: Int {
        case val = 999
    }
    
    
    var myUserProfile: UserProfile? {
        didSet {
            // Views is set after knowing how long the texts are.
            
            // When myUserProfile is set within the UserController as a cell, then load up the required information that the user has.
            createQR(myUserProfile!)
            setupViews()
        }
    }

    
    func createJSON(_ profile: UserProfile) -> String {
        var jsonDict: [String: String] = [:]
        for key in (profile.entity.attributesByName.keys) {
            if (profile.value(forKey: key) != nil && UIManager.makeShortHandForQR(key) != nil) {
                    jsonDict[UIManager.makeShortHandForQR(key)!] = profile.value(forKey: key) as? String
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
        //qrImageView?.image = UIImage(named: "familiarize_website_qr-1")
    }
    
    let profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 350.0 / 2.0)
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
            //self.fullBrightness = false
            addSubview(bioLabel)
            
            if (myUserProfile?.name) == "T.J. Miller" {
                profileImage.layer.masksToBounds = true
                profileImage.image = UIImage(named: "tjmiller6")
            }
            else {
                profileImage.image = UIImage(named: "tjmiller7")
            }
            addSubview(profileImage)
            profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 100).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -160).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 350.0).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 350.0).isActive = true
            //profileImage.bounds.size.width = (self.qrImageView?.bounds.width)!
            print("profileImage frame size = ", profileImage.frame.size)
            print("profileImage frame width = ", profileImage.frame.size.width)
            print("profileimage bounds = ", profileImage.bounds.size.width)
            print("next = " , self.qrImageView?.bounds.width)
            profileImage.clipsToBounds = true
            
            //Namelabel position upated using NSLayoutConstraint -dan
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            let name_topConstraint = NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            let name_bottomConstraint = NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 290)
            let name_leadingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 35)
            let name_trailingConstraint = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            addSubview(nameLabel)
            addConstraints([name_topConstraint, name_bottomConstraint, name_leadingConstraint, name_trailingConstraint])
            layoutIfNeeded()
            let name = NSMutableAttributedString(string: (myUserProfile?.name)!, attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 25)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
            nameLabel.attributedText = name
            
            //Biolabel position updated using NSLayoutConstraint -dan
            bioLabel.translatesAutoresizingMaskIntoConstraints = false
            let bio_topConstraint = NSLayoutConstraint(item: bioLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            let bio_bottomConstraint = NSLayoutConstraint(item: bioLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 350)
            let bio_leadingConstraint = NSLayoutConstraint(item: bioLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 35)
            let bio_trailingConstraint = NSLayoutConstraint(item: bioLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            addSubview(bioLabel)
            addConstraints([bio_topConstraint, bio_bottomConstraint, bio_leadingConstraint, bio_trailingConstraint])
            let bio = NSMutableAttributedString(string: (myUserProfile?.bio)!, attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 18)!, NSForegroundColorAttributeName: UIColor(red:144/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1.0)])
            bioLabel.attributedText = bio
            
            
            presentSocialMediaButtons()
            onQRImage = false
        } else {
            //UIScreen.main.brightness = 1.0
            //self.fullBrightness = true
            addSubview(qrImageView!)
            qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
            qrImageView?.heightAnchor.constraint(equalToConstant: 300).isActive = true
            qrImageView?.widthAnchor.constraint(equalToConstant: 300).isActive = true
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
        "twitterProfile": UIManager.makeImage(imageName: "dan_twitter_black"),
        "soundCloudProfile": UIManager.makeImage(imageName: "dan_soundcloud_black"),
        ]
    
    //Helper function to space out social media icons - dan
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
    
    //Function to space out social media icons evenly around the profile picture at an equal distance -dan
    func presentSocialMediaButtons() {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                print(key)
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        let size = my_imagesToPresent.count
        print(size)
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
