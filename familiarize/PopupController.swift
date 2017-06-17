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
import SwiftyJSON
import CoreData
import M13Checkbox

class PopupController: UIViewController {
    
    var userProfile: UserProfile?
    var QRScannerDelegate: QRScannerControllerDelegate?
    
    // When everything is done loading, do this shabang.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
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
    
    var profileImage: UIImageView = {
        return UIManager.makeImage()
    }()
    
    lazy var dismissFriendButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dismiss-button")
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var viewProfileButton: UIButton = {
        let button = UIManager.makeButton(imageName: "viewprofile-button")
        button.addTarget(self, action: #selector(viewProfileClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        button.frame = self.view.bounds
        return button
    }()
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the 
    // QRScannerController view controller. And also pops this view controller from the stack.
    func dismissClicked() {
        QRScannerDelegate?.commenceCameraScanning()
        self.dismiss(animated: false)
    }

    // Function handles what happens when user clicks on the "view profile" button.
    // Basically, it unstacks all of the view controllers upto the rootview controller. 
    // The root view controller is the tabview controller.
    // And then it selects the first tab of the rootview controller, which is the contacts page. 
    // After making the contacts page open, then a notification is passed. The notification 
    // tells the contacts page to open up the very first cell and to display the user's information.
    func viewProfileClicked() {
        // Go to different VC
        if self.view.window?.rootViewController as? CustomTabBarController != nil {
            let tabBarController = self.view.window!.rootViewController as! CustomTabBarController
            tabBarController.selectedIndex = 0
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        NotificationCenter.default.post(name: .viewProfile, object: nil)
    }
    
    // Customized checkbox that is supposed to show the user that another user has been added.
    //https://github.com/Marxon13/M13Checkbox
    let checkBox: M13Checkbox = {
        let cb = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        cb.stateChangeAnimation = .spiral
        cb.animationDuration = 0.75
        cb.boxType = .circle
        cb.checkmarkLineWidth = 2.0
        cb.secondaryTintColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        cb.tintColor = UIColor(red: 37/255, green: 60/255, blue: 97/255, alpha: 1.0)
        cb.secondaryCheckmarkTintColor = UIColor(red: 37/255, green: 60/255, blue: 97/255, alpha: 1.0)
        cb.translatesAutoresizingMaskIntoConstraints = false
        return cb
    }()
    
    // The effect for making a blurry background
    lazy var backgroundBlur: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    // Slides up the popup from the bottom of the screen to the middle
    var popupCenterYAnchor: NSLayoutConstraint?
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.setupGraphics()
        })
    }
 
    // For setting up the popup background, the checkbox (but not fully animating it), and also the blurry background
    func setupBackground() {
        view.addSubview(outsideButton)
        view.addSubview(backgroundBlur)
        view.addSubview(popupImageView)
        view.addSubview(self.checkBox)

        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
        
        self.checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.hideBox = true
    }
    
    
    // For putting the name on the popup VC
    func printName() {
        let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = attributedText
    }
    func setupGraphics() {

        printName()
        
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        view.addSubview(self.viewProfileButton)
        view.addSubview(self.dismissFriendButton)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 93).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 93).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 15).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true

        viewProfileButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 120).isActive = true
        viewProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewProfileButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        dismissFriendButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 160).isActive = true
        dismissFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissFriendButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissFriendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.checkBox.setCheckState(.checked, animated: true)


    }
    
    // This makes the profile image into a circle. 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
}
