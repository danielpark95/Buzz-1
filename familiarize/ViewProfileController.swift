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
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    
    // FYI the button should be a facebook button
    lazy var fbButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_instagram")
        button.addTarget(self, action: #selector(didSelectFB), for: .touchUpInside)
        return button
    }()
    
    lazy var igButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_instagram")
        button.addTarget(self, action: #selector(didSelectIG), for: .touchUpInside)
        return button
    }()
    
    lazy var scButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_snapchat")
        button.addTarget(self, action: #selector(didSelectSC), for: .touchUpInside)
        return button
    }()
    
    lazy var pnButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_phone")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var emButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_phone")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    lazy var inButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_phone")
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
        ]
    }

    let socialMedia = [
        "faceBookProfile": "fb",
        "instagramProfile": "ig",
        "snapChatProfile": "sc" ,
        "phoneNumber": "pn",
        "email": "em",
        "linkedInProfile": "in",
    ]
    
    func presentSocialMediaButtons() {

        var spacing: CGFloat = 20
        
        if self.userProfile != nil {
            for key in (self.userProfile?.entity.attributesByName.keys)! {
                if (userProfile?.value(forKey: key) != nil && socialMedia[key] != nil) {
                    let shortHand: String = socialMedia[key]!
                    view.addSubview((socialMediaButtons?[shortHand])!)
                    (socialMediaButtons?[shortHand])!.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 100).isActive = true
                    (socialMediaButtons?[shortHand])!.leftAnchor.constraint(equalTo: popupImageView.leftAnchor, constant: spacing).isActive = true
                    (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    
                    spacing += 60
                }
            }
        }
    }
    
    override func dismissClicked() {
        self.dismiss(animated: false)
    }
    
    override func setDismissButton() {
        dismissButton = UIManager.makeButton(imageName: "dismiss-button")
        view.addSubview(self.dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 73).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    override func addToGraphics() {
        

        
        view.addSubview(self.profileImage)
        view.addSubview(self.nameAndBioLabel)
        
        
        createSocialMediaButtons()
        presentSocialMediaButtons()
        
        profileImage.leftAnchor.constraint(equalTo: popupImageView.leftAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 20).isActive = true
        
        // Set to 80 --> Then you also have to change the corner radius to 40 ..
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true

        nameAndBioLabel.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 20).isActive = true
        
        nameAndBioLabel.leftAnchor.constraint(equalTo: popupImageView.leftAnchor, constant: 120).isActive = true
        nameAndBioLabel.heightAnchor.constraint(equalToConstant: nameAndBioLabel.intrinsicContentSize.height).isActive = true
        nameAndBioLabel.widthAnchor.constraint(equalToConstant:nameAndBioLabel.intrinsicContentSize.width).isActive = true
    }
    
    override func setPopup() {
        self.popupImageView = UIManager.makeImage(imageName: "view-profile-popup")

        let tap = UITapGestureRecognizer()
        self.popupImageView.addGestureRecognizer(tap)
        self.popupImageView.isUserInteractionEnabled = true
        
        view.addSubview(self.popupImageView)
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 222).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 339).isActive = true
    }
    
    override func setNameAndBio() {
        var attributedText = NSMutableAttributedString()
        
        if let name = userProfile?.name {
            attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26), NSForegroundColorAttributeName: UIColor.white])
        }

        if let bio = userProfile?.bio {
            attributedText.append(NSAttributedString(string:"\n\(bio)" , attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.white]))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, (attributedText.string.characters.count)))
        
        nameAndBioLabel.attributedText = attributedText
    }
    override func addToBackground() {
        view.addSubview(tintOverlay)
        view.sendSubview(toBack: tintOverlay)
    }
}
