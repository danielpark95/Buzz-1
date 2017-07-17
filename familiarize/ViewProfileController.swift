//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class ViewProfileController: ProfilePopupBase {
    var socialMediaButtons: [String : UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage()
    }

    func buttonLink(_ userURL: String) {
        
        // Lmao, in order to get profile id, just scrape the facebook page again.
        // <meta property="al:ios:url" content="fb://profile/100001667117543">
        
        let fbURL = URL(string: "fb://profile?id=100001667117543")!
        
        let safariFBURL = URL(string: "https://www.facebook.com/100001667117543")!
        
        if UIApplication.shared.canOpenURL(fbURL)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(fbURL)
            }
            
        } else {
            //redirect to safari because the user doesn't have facebook application
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(safariFBURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(safariFBURL)
            }
        }
    }
    
    func didSelectFB() {
        buttonLink("Kabooya")
    }
    
    func didSelectIG() {
        buttonLink("Kabooya")
    }
    
    func didSelectSC() {
        buttonLink("Kabooya")
    }
    
    func didSelectPN() {
        buttonLink("Kabooya")
    }
    
    lazy var tintOverlay: UIImageView = {
        let visualEffect = UIManager.makeImage()
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    // FYI the button should be a facebook button
    lazy var fbButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_facebook_black")
        button.addTarget(self, action: #selector(didSelectFB), for: .touchUpInside)
        return button
    }()
    
    lazy var igButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_instagram_black")
        button.addTarget(self, action: #selector(didSelectIG), for: .touchUpInside)
        return button
    }()
    
    lazy var scButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_snapchat_black")
        button.addTarget(self, action: #selector(didSelectSC), for: .touchUpInside)
        return button
    }()
    
    lazy var pnButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_phone_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var emButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_email_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    lazy var inButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_linkedin_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var soButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_soundcloud_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    lazy var twButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_twitter_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    func createSocialMediaButtons() {
        socialMediaButtons = [
            "fb": fbButton,
            "ig": igButton,
            "sc": scButton,
            "pn": pnButton,
            "in": emButton,
            "em": inButton,
            "so": soButton,
            "tw": twButton,
        ]
    }
    
    let socialMedia = [
        "faceBookProfile": "fb",
        "instagramProfile": "ig",
        "snapChatProfile": "sc" ,
        "phoneNumber": "pn",
        "email": "em",
        "linkedInProfile": "in",
        "soundCloudProfile": "so",
        "twitterProfile": "tw",
        ]
    
    func presentSocialMediaButtons() {
        var xSpacing: CGFloat = 50
        var ySpacing: CGFloat = 10
        let yConstant: CGFloat = 50
        var shortHandArray = [String]()
        for key in (self.userProfile?.entity.attributesByName.keys)! {
            if (userProfile?.value(forKey: key) != nil && socialMedia[key] != nil) {
                shortHandArray.append(socialMedia[key]!)
            }
        }
        let size = shortHandArray.count
        var count = 0
        
        if size == 1 {
            count = 0
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + yConstant).isActive = true
                count += 1
                if count == 1{
                    break
                }
            }
        } else if size == 2 {
            count = 0
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + yConstant).isActive = true
                xSpacing = xSpacing * (-1)
                count += 1
                if count == 2{
                    break
                }

            }
            
        } else if size == 3 {
            count = 0
            ySpacing = 20
            
            
            for shortHand in shortHandArray {
                
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count < 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + yConstant).isActive = true
                }
                
                count += 1
                if count == 3 {
                    break
                }
            }
        } else if size == 4 {
            count = 0
            ySpacing = 20
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count < 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count < 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                count += 1
                if count == 4 {
                    break
                }
            }
        } else if size == 5 { //5 looks good
            count = 0
            xSpacing = 80
            ySpacing = 15
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                } else if count == 3 {
                    xSpacing = 45
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                } else if count == 4 {
                    xSpacing = 45
                    xSpacing = xSpacing * (-1)
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                }
                count += 1
                if count == 5 {
                    break
                }
            }
        } else if size == 6 { //6 looks good
            count = 0
            xSpacing = 80
            ySpacing = 15
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                } else if count == 3 || count == 5 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                }
                count += 1
                if count == 6 {
                    break
                }
            }
        } else {
            //write code for when there are more than 6 linked accounts
        }
    }
    
    override func dismissClicked() {
        self.dismiss(animated: false)
    }
    
    override func setDismissButton() {
        dismissButton = UIManager.makeButton(imageName: "dan_close_text")
        view.addSubview(self.dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 160).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
    }
    
    func drawMiddleLine() {
        let middleLine = UIManager.makeImage(imageName: "dan_popup_middle_bar")
        view.addSubview(middleLine)
        middleLine.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        middleLine.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 0).isActive = true
    }
    
    override func addToGraphics() {
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        view.addSubview(self.bioLabel)
        
        //drawMiddleLine()
        createSocialMediaButtons()
        presentSocialMediaButtons()
        
        profileImage.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 10).isActive = true
        
        // Set to 80 --> Then you also have to change the corner radius to 40 ..
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 120).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.width).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 155).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.width).isActive = true
    }
    
    override func setPopup() {
        view.addSubview(self.tintOverlay)
        self.popupImageView = UIManager.makeImage(imageName: "dan_popup_small")
        let tap = UITapGestureRecognizer()
        self.popupImageView.addGestureRecognizer(tap)
        self.popupImageView.isUserInteractionEnabled = true
        view.addSubview(self.popupImageView)
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true        
    }
    
    override func setName(){
        var attributedText = NSMutableAttributedString()
        if let name = userProfile?.name {
            attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
        }
        nameLabel.attributedText = attributedText
    }
    
    override func setBio(){
        var attributedText = NSMutableAttributedString()
        if let bio = userProfile?.bio {
            attributedText = NSMutableAttributedString(string: bio, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
        }
        bioLabel.attributedText = attributedText
    }
    override func addToBackground() {
//        view.sendSubview(toBack: tintOverlay)
        //self.tintOverlay.sendSubview(toBack: popupImageView)
        //view.sendSubview(toBack: self.tintOverlay)
        view.bringSubview(toFront: popupImageView)
    }
}
