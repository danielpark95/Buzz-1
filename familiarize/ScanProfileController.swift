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
    
    var ScannerControllerDelegate: ScannerControllerDelegate?
    var userProfile: UserProfile?
    let profileImageHeightAndWidth: CGFloat = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePopup()
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // This makes the profile image into a circle.
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    // MARK: - UI Properties
    let nameLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.isHidden = true
        return label
    }()
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage(imageName: "dan_profilepopup_square")
        let tap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIManager.makeProfileImage(valueOfCornerRadius: self.profileImageHeightAndWidth/2)
        image.isHidden = true
        return image
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_close_text")
        button.isHidden = true
        return button
    }()
    
    lazy var outsideButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    // The effect for making a blurry background
    lazy var backgroundBlur: UIVisualEffectView = {
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.alpha = 0
        return visualEffect
    }()
    
    // Customized checkbox that is supposed to show the user that another user has been added.
    //https://github.com/Marxon13/M13Checkbox
    let checkBox: M13Checkbox = {
        let cb = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        cb.stateChangeAnimation = .spiral
        cb.animationDuration = 0.5
        cb.boxType = .circle
        cb.markType = .checkmark
        cb.checkmarkLineWidth = 2.0
        cb.secondaryTintColor = UIColor(red: 46/255, green: 202/255, blue: 209/255, alpha: 1.0)
        cb.tintColor = UIColor(red: 46/255, green: 202/255, blue: 209/255, alpha: 1.0)
        cb.secondaryCheckmarkTintColor = UIColor(red: 46/255, green: 202/255, blue: 209/255, alpha: 1.0)
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.hideBox = true
        return cb
    }()
    
    lazy var viewProfileButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_viewprofile_blue")
        button.addTarget(self, action: #selector(viewProfileClicked), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var popupCenterYAnchor: NSLayoutConstraint?
    var profileImageCenterYAnchor: NSLayoutConstraint?
    func setupViews() {
        view.addSubview(backgroundBlur)
        view.addSubview(outsideButton)
        view.addSubview(popupImageView)
        view.addSubview(checkBox)
        view.addSubview(viewProfileButton)
        view.addSubview(nameLabel)
        view.addSubview(profileImage)
        view.addSubview(dismissButton)
        
        backgroundBlur.frame = view.bounds
        
        outsideButton.frame = view.bounds
        
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        popupCenterYAnchor?.isActive = true
        
        checkBox.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 5).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        profileImageCenterYAnchor = profileImage.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -50)
        profileImageCenterYAnchor?.isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: profileImageHeightAndWidth).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: profileImageHeightAndWidth).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -30).isActive = true
        
        viewProfileButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        viewProfileButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 45).isActive = true
        
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 81).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
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
        dismissClicked()
        ScannerControllerDelegate?.stopCameraScanning()
        NotificationCenter.default.post(name: .viewProfile, object: nil)
    }
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the
    // QRScannerController view controller. And also pops this view controller from the stack.
    func dismissClicked() {
        // TODO: There's an error that occurs where while the camera is still pointing at the qr code, the camera begins to scan, while the view has not been dismissed yet.
        ScannerControllerDelegate?.startCameraScanning()
        popupCenterYAnchor?.constant = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.backgroundBlur.alpha = 0.0
        }, completion: { _ in
            self.dismiss(animated: false, completion: {
                // Unchecks the animation, so that on rescan, it does the animation again.
                self.checkBox.setCheckState(.unchecked, animated: false)
                // Resets the profile image to always start from 50 pixels below so that it animates correctly on scan.
                self.profileImageCenterYAnchor?.constant = -50
                self.profileImage.isHidden = true
                self.nameLabel.isHidden = true
                self.viewProfileButton.isHidden = true
                self.dismissButton.isHidden = true
                self.checkBox.isHidden = true
                self.removeFromParentViewController()
            })
        })
    }
    
    // MARK: - Animating popup display
    // Slides up the popup from the bottom of the screen to the middle
    func animatePopup() {
        popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.backgroundBlur.alpha = 1.0
        }, completion: nil)
    }
    
    func setUserName(_ userProfileName: String) {
        let userProfileName = NSMutableAttributedString(string: userProfileName, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = userProfileName
        self.nameLabel.isHidden = false
        self.viewProfileButton.isHidden = false
        self.dismissButton.isHidden = false
        self.checkBox.isHidden = false
        UIView.animate(withDuration: 0, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.checkBox.setCheckState(.checked, animated: true)
        }, completion: nil)
    }
    
    func setUserProfileImage(_ fetchedProfileImage: UIImage) {
        self.profileImage.image = fetchedProfileImage
        profileImageCenterYAnchor?.constant = -100
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.profileImage.isHidden = false
        }, completion: nil)
    }
}
