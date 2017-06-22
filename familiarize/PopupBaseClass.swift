//
//  PopupController.swift
//  familiarize
//
//  Created by Alex Oh on 6/3/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

// Popup -- https://www.youtube.com/watch?v=DmWv-JtQH4Q
// Color -- 37 | 60 | 97
// NSCoreData -- https://www.youtube.com/watch?v=TW_jcvVvPwI -- Also need to maybe clear the data from this simulator? No idea (:


import UIKit
import CoreData

class PopupBase: UIViewController {
    
    var userProfile: UserProfile?
    
    // When everything is done loading, do this shabang.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.addToBackground()
    }
    
    // After all of the views are setups, then animate the motion where the popup image
    // starts to rise up from the bottom of the screen to the middle.
    override func viewDidAppear(_ animated: Bool) {
        self.animatePopup()
    }
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let nameLabel: UILabel = {
        return UIManager.makeLabel()
    }()
    
    let popupImageView: UIButton = {
        let button = UIManager.makeButton(imageName: "popup-image")
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    lazy var profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 47)
    }()
    
    lazy var dismissFriendButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dismiss-button")
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the
    // QRScannerController view controller. And also pops this view controller from the stack.
    func dismissClicked() {
        self.dismiss(animated: false)
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    var popupCenterYAnchor: NSLayoutConstraint?
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.setupGraphics()
            self.addToGraphics()
        })
    }
    
    // For setting up the popup background, the checkbox (but not fully animating it), and also the blurry background
    func setupBackground() {
        view.addSubview(self.outsideButton)
        view.addSubview(self.popupImageView)
        
        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
    }
    
    
    // For putting the name on the popup VC
    func printName() {
        let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = attributedText
    }
    func setupGraphics() {
        
        printName()
        
        if userProfile?.profileImage != nil {
            self.profileImage.image = UIImage(data: (userProfile?.profileImage!)!)
            self.profileImage.clipsToBounds = true
        }
        
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        view.addSubview(self.dismissFriendButton)
        
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 94).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 94).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 15).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        dismissFriendButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 160).isActive = true
        dismissFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissFriendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissFriendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func addToGraphics() {
        
    }
    
    func addToBackground() {
        
    }
    
    // This makes the profile image into a circle. 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }

}
