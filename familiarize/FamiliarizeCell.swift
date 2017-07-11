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
            UIScreen.main.brightness = 1.0
        } else {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            UIScreen.main.brightness = delegate.userBrightnessLevel
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
        qrCode?.backgroundColor = CIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
        qrImageView = UIManager.makeImage()
        qrImageView?.image = qrCode?.image
    }
    
    lazy var cardBorder: UIImageView = {
        let image = UIManager.makeImage(imageName: "dan_card_border")
        image.tag = borderTag.val.rawValue
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
        
    }()
    
    func flip() {
        
        for v in (self.subviews){
            if v.tag != borderTag.val.rawValue {
                v.removeFromSuperview()
            }
        }
        
        if onQRImage == true {
            self.fullBrightness = false
            addSubview(bioLabel)
            
            let bio = NSMutableAttributedString(string: "Palo Alto, 29, Coffee Enthusiast", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)])
            
            bioLabel.attributedText = bio
            
            bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            bioLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
            bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
            bioLabel.widthAnchor.constraint(equalToConstant:bioLabel.intrinsicContentSize.width).isActive = true
            presentSocialMediaButtons()
            
            onQRImage = false
        } else {
            UIScreen.main.brightness = 1.0
            self.fullBrightness = true
            addSubview(qrImageView!)
            qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
            qrImageView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
            qrImageView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
            onQRImage = true
        }
    }
    
    
    func setupViews() {
        addSubview(cardBorder)
        flip()
        cardBorder.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cardBorder.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        cardBorder.heightAnchor.constraint(equalToConstant: 350).isActive = true
        cardBorder.widthAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    lazy var socialMediaImages: [String: UIImageView] = [
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebook_red"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagram_red"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapchat_red"),
        "phoneNumber": UIManager.makeImage(imageName: "dan_phone_red"),
        "linkedInProfile": UIManager.makeImage(imageName: "dan_linkedin_red"),
        "email": UIManager.makeImage(imageName: "dan_email_red"),
        ]
    
    
    func presentSocialMediaButtons() {
        var xSpacing: CGFloat = 50
        var ySpacing: CGFloat = 10
    
        var imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                print(key)
                imagesToPresent.append(socialMediaImages[key]!)
            }
        }
        let size = imagesToPresent.count
        
        var count = 0
        //size = 3
        
        if size == 1 {
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: ySpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 70).isActive = true
                image.widthAnchor.constraint(equalToConstant: 70).isActive = true

                count += 1
                if count == 1{
                    break
                }
            }
        } else if size == 2 {
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: ySpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 70).isActive = true
                image.widthAnchor.constraint(equalToConstant: 70).isActive = true

                xSpacing = xSpacing * (-1)
                count += 1
                if count == 2{
                    break
                }
            }
        } else if size == 3 {
            count = 0
            ySpacing = 20
            for image in imagesToPresent {
                if count < 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count == 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 3*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }

                count += 1
                if count == 3{
                    break
                }
            }
        } else if size == 4 {
            count = 0
            print("size = 4")
            ySpacing = 20
            for image in imagesToPresent {
                if count < 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count < 4 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 3*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                count += 1
                if count == 4{
                    break
                }
            }
        } else if size == 5 {
            count = 0
            xSpacing = 80
            ySpacing = 15
            for image in imagesToPresent {
                if count == 0 || count == 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count == 1 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }
                else if count == 3{
                    xSpacing = 45
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 4*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }
                else if count == 4{
                    xSpacing = 45
                    xSpacing = xSpacing * (-1)
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 4*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }
                count += 1
                if count == 5{
                    break
                }
            }
        } else if size == 6 {
            count = 0
            xSpacing = 80
            ySpacing = 15
            for image in imagesToPresent {
                if count == 0 || count == 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count == 1 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }
                if count == 3 || count == 5 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 4*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count == 4 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 4*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }
                count += 1
                if count == 6{
                    break
                }
            }
        }
        else {
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
                image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xSpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                
                xSpacing += 60
                count += 1
                if count == 6{
                    break
                }
            }
        }

    }
}
