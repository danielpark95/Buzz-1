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

// https://github.com/Marxon13/M13Checkbox
// Checkmark animation

// Also really need to change up the code structure. Everything related to coredata should be moved elsewhere to like coredataManager. 


class PopupController: UIViewController {
    
    var userProfile: UserProfile?
    var QRScannerDelegate: QRScannerControllerDelegate?
    
    enum buttonTag: Int {
        case profile = 1
        case dismiss = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let nameLabel: UILabel = {
        return UIManager.makeLabel()
    }()
    
    let popupImageView: UIImageView = {
        return UIManager.makeImage(imageName: "popup-image")
    }()
    
    var profileImage: UIImageView = {
        return UIManager.makeImage()
    }()
    
    lazy var dismissFriendButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dismiss-button", tag: buttonTag.dismiss.rawValue)
        button.addTarget(self, action: #selector(buttonFunction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var viewProfileButton: UIButton = {
        let button = UIManager.makeButton(imageName: "viewprofile-button", tag: buttonTag.profile.rawValue)
        button.addTarget(self, action: #selector(buttonFunction(sender:)), for: .touchUpInside)
        return button
    }()

    func buttonFunction(sender: UIButton) {
        if (sender.tag == buttonTag.dismiss.rawValue) {
            QRScannerDelegate?.commenceCameraScanning()
            self.dismiss(animated: false)
        } else if (sender.tag == buttonTag.profile.rawValue) {
            // Go to different VC
            self.dismiss(animated: false)
            // Code for going back to the viewprofile
        }
        // https://stackoverflow.com/questions/5413538/switching-to-a-tabbar-tab-view-programmatically
        // This needs to be called so that we skip view controller.
    }
    
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
    
 
    func setupBackground() {
        view.addSubview(popupImageView)
        view.addSubview(checkBox)
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
        
        self.checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupText() {
        let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = attributedText
    }
    func setupGraphics() {

        setupText()
        
        view.addSubview(self.profileImage)
        view.addSubview(nameLabel)
        view.addSubview(viewProfileButton)
        view.addSubview(dismissFriendButton)

        checkBox.setCheckState(.checked, animated: true)
        
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

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
}
