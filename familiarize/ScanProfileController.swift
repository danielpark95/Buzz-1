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
import M13Checkbox

class ScanProfileController: UIViewController {
    
    var QRScannerControllerDelegate: QRScannerControllerDelegate?
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPopup()
        self.setupBackground()
        self.addToBackground()
        self.setupGraphics()
        self.addToGraphics()
        
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
    // The effect for making a blurry background
    lazy var backgroundBlur: UIVisualEffectView = {
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
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
    
    lazy var viewProfileButton: UIButton = {
        let button = UIManager.makeButton(imageName: "view-profile-button")
        button.addTarget(self, action: #selector(viewProfileClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Setting up views
    
    func setPopup() {
        self.popupImageView = UIManager.makeImage(imageName: "scan-profile-popup")
        let tap = UITapGestureRecognizer()
        self.popupImageView.addGestureRecognizer(tap)
        self.popupImageView.isUserInteractionEnabled = true
        
        view.addSubview(self.popupImageView)
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor?.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 182).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 217).isActive = true
    }
    
    // For setting up the popup background, the checkbox (but not fully animating it), and also the blurry background
    func setupBackground() {
        self.view.addSubview(self.backgroundBlur)
        self.view.sendSubview(toBack: self.backgroundBlur)
        view.addSubview(self.outsideButton)
        
        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
    }
    
    func addToBackground() {
        view.addSubview(self.checkBox)
        
        self.checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.hideBox = true
    }
    
    func setupGraphics() {
        setName()
        setDismissButton()
    }
    
    func addToGraphics() {
        view.addSubview(self.viewProfileButton)
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        
        profileImage.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -100).isActive = true
        
        // Set to 80 --> Then you also have to change the corner radius to 40 ..
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        nameLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -30).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        viewProfileButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        viewProfileButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 40).isActive = true
        viewProfileButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        viewProfileButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    

    func viewProfileClicked() {
        // Go to different VC
        if self.view.window?.rootViewController as? TabBarController != nil {
            // Must get access to the original tab bar controller.
            let tabBarController = self.view.window!.rootViewController as! TabBarController
            // Switch to the third page, which is the contacts page.
            tabBarController.selectedIndex = 2
            // Since the viewdiddisappear doesnt get called within familiarizecontroller, we have to manually display the tab bar.
            tabBarController.tabBar.isHidden = false
        }
        self.QRScannerControllerDelegate?.startCameraScanning()
        setupDismiss()
        NotificationCenter.default.post(name: .viewProfile, object: nil)
    }
    
    // MARK: - Animating popup display
    
    func setupDismiss() {
        self.dismiss(animated: false, completion: {
            // Brings the popup image to the bottom again.
            self.popupCenterYAnchor?.constant = self.view.frame.size.height
            // Unchecks the animation, so that on rescan, it does the animation again.
            self.checkBox.setCheckState(.unchecked, animated: false)
        })
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    var popupCenterYAnchor: NSLayoutConstraint?
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.animateAfterPopup()
            
        })
        
    }
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the
    // QRScannerController view controller. And also pops this view controller from the stack.
    func dismissClicked() {
        self.QRScannerControllerDelegate?.startCameraScanning()
        setupDismiss()
    }
    
    // MARK: - Assigning UI Properties (Label, Button, Lines)
    
    func setDismissButton() {
        dismissButton = UIManager.makeButton(imageName: "dismiss-button-color")
        view.addSubview(self.dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 73).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    
    func setName() {
        let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = attributedText
    }
    
    func setImage() {
        if userProfile?.profileImage != nil {
            self.profileImage.image = UIImage(data: (userProfile?.profileImage!)!)
            self.profileImage.clipsToBounds = true
        }
    }
    
    func animateAfterPopup() {
        self.checkBox.setCheckState(.checked, animated: true)
    }
}
