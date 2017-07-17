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

class ScanProfileController: ProfilePopupBase {
    
    var QRScannerControllerDelegate: QRScannerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // The effect for making a blurry background
    lazy var backgroundBlur: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
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
    
    // Function handles what happens when user clicks on the "view profile" button.
    // Basically, it unstacks all of the view controllers upto the rootview controller.
    // The root view controller is the tabview controller.
    // And then it selects the first tab of the rootview controller, which is the contacts page.
    // After making the contacts page open, then a notification is passed. The notification
    // tells the contacts page to open up the very first cell and to display the user's information.
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
    
    func setupDismiss() {
        self.dismiss(animated: false, completion: {
            // Brings the popup image to the bottom again.
            self.popupCenterYAnchor?.constant = self.view.frame.size.height
            // Unchecks the animation, so that on rescan, it does the animation again.
            self.checkBox.setCheckState(.unchecked, animated: false)
        })
    }
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the
    // QRScannerController view controller. And also pops this view controller from the stack.
    override func dismissClicked() {
        self.QRScannerControllerDelegate?.startCameraScanning()
        setupDismiss()
    }
    
    override func setPopup() {
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
    
    override func addToBackground() {
        
        view.addSubview(backgroundBlur)
        view.sendSubview(toBack: backgroundBlur)
        view.addSubview(self.checkBox)
        
        self.checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 5).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.hideBox = true
        
    }
    
    override func setDismissButton() {
        dismissButton = UIManager.makeButton(imageName: "dismiss-button-color")
        view.addSubview(self.dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 73).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    override func addToGraphics() {
        view.addSubview(self.viewProfileButton)
        view.addSubview(self.profileImage)
        view.addSubview(self.nameLabel)
        view.addSubview(self.bioLabel)
        //view.addSubview(self.nameAndBioLabel)
        
        profileImage.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -100).isActive = true
        
        // Set to 80 --> Then you also have to change the corner radius to 40 ..
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        nameLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -30).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        bioLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        bioLabel.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -10).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.width).isActive = true
        
        
        
//        
//        nameAndBioLabel.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
//        nameAndBioLabel.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -30).isActive = true
//        nameAndBioLabel.heightAnchor.constraint(equalToConstant: nameAndBioLabel.intrinsicContentSize.height).isActive = true
//        nameAndBioLabel.widthAnchor.constraint(equalToConstant:nameAndBioLabel.intrinsicContentSize.width).isActive = true
//        
        viewProfileButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        viewProfileButton.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 40).isActive = true
        viewProfileButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        viewProfileButton.widthAnchor.constraint(equalToConstant: 150).isActive = true

    }
    
    override func animateAfterPopup() {
        self.checkBox.setCheckState(.checked, animated: true)
    }
}
