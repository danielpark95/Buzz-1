//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class ViewProfileController: UIViewController {
    var socialMediaButtons: [String : UIButton]?
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPopup()
        self.setupBackground()
        self.addToBackground()
        self.setupGraphics()
        self.addToGraphics()
        self.setImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePopup()
    }
    
    // This makes the profile image into a circle.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    // MARK: - UI Properties
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let nameAndBioLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 2)
    }()
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    let bioLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage()
        
        return imageView
    }()
    
    lazy var profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 50)
    }()
    
    lazy var dismissButton: UIButton = {
        return UIManager.makeButton()
    }()
    
    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setting up views
    
    func setPopup() {
        self.popupImageView = UIManager.makeImage(imageName: "dan_popup")
        
        let tap = UITapGestureRecognizer()
        self.popupImageView.addGestureRecognizer(tap)
        self.popupImageView.isUserInteractionEnabled = true
        
        view.addSubview(self.popupImageView)
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
    }
    
    // For setting up the popup background, the checkbox (but not fully animating it), and also the blurry background
    func setupBackground() {
        
        view.addSubview(self.outsideButton)
        
        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
    }
    
    func addToBackground() {
        view.addSubview(tintOverlay)
        view.sendSubview(toBack: tintOverlay)
    }
    
    func setupGraphics() {
        setName()
        setBio()
        setDismissButton()
    }
    
    func addToGraphics() {
        
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        view.addSubview(self.bioLabel)
        
        drawMiddleLine()
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
        
        bioLabel.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 150).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.width).isActive = true
    }
    
    func setImage() {
        if userProfile?.profileImage != nil {
            self.profileImage.image = UIImage(data: (userProfile?.profileImage!)!)
            self.profileImage.clipsToBounds = true
        }
    }
    
    // MARK: - Animating popup display
    
    func dismissClicked() {
        self.popupCenterYAnchor?.constant = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tintOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.dismiss(animated: false)
        })
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    var popupCenterYAnchor: NSLayoutConstraint?
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tintOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.10)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Assigning UI Properties (Label, Button, Lines)
    
    func setDismissButton() {
        dismissButton = UIManager.makeButton(imageName: "dan_close")
        view.addSubview(self.dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 190).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
    }
    
    func drawMiddleLine() {
        let middleLine = UIManager.makeImage(imageName: "dan_popup_middle_bar")
        view.addSubview(middleLine)
        middleLine.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        middleLine.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -10).isActive = true
    }
    
    func setName(){
        var attributedText = NSMutableAttributedString()
        if let name = userProfile?.name {
            attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
        }
        nameLabel.attributedText = attributedText
    }
    
    func setBio() {
        var attributedText = NSMutableAttributedString()
        if let bio = userProfile?.bio {
            attributedText = NSMutableAttributedString(string: bio, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
        }
        bioLabel.attributedText = attributedText
    }
    
    // MARK: - Button Properties
    
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
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        visualEffect.frame = (delegate.window?.bounds)!
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
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + 50).isActive = true
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
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + 50).isActive = true
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
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + 50).isActive = true
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
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count < 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                count += 1
                if count == 4 {
                    break
                }
            }
        } else if size == 5 {
            count = 0
            xSpacing = 80
            ySpacing = 15
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                } else if count == 3 {
                    xSpacing = 45
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + 50).isActive = true
                } else if count == 4 {
                    xSpacing = 45
                    xSpacing = xSpacing * (-1)
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + 50).isActive = true
                }
                count += 1
                if count == 5 {
                    break
                }
            }
        } else if size == 6 {
            count = 0
            xSpacing = 80
            ySpacing = 15
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + 50).isActive = true
                } else if count == 3 || count == 5 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + 50).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + 50).isActive = true
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
}
