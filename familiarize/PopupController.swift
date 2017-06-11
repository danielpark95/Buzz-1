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

class PopupController: UIViewController {
    
    enum buttonTag: Int {
        case profile = 1
        case dismiss = 2
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    
    
    var qrJSON: JSON = []
    
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let popupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popup-image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var dismissFriendButton: UIButton = {
        self.makeButton(imageName: "dismiss-button", tag: buttonTag.dismiss.rawValue)
    }()
    
    lazy var viewProfileButton: UIButton = {
        self.makeButton(imageName: "viewprofile-button", tag: buttonTag.profile.rawValue)
    }()
    
    
    func makeButton(imageName: String, tag: Int) -> UIButton {
        let image = UIImage(named: imageName) as UIImage?
        let button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        return button
    }
    
    var QRScannerDelegate: QRScannerControllerDelegate?
    func buttonClicked(sender: UIButton) {
        if (sender.tag == buttonTag.dismiss.rawValue) {
            QRScannerDelegate?.commenceCameraScanning()
            self.dismiss(animated: false)
        } else if (sender.tag == buttonTag.profile.rawValue) {
            // Go to different VC
            self.dismiss(animated: false)
            // Code for going back to the viewprofile
        }
        setupData()
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
    
    func setupData() {
        // NSCore data functionalities. -- Persist the data when user scans!
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
        newUser.name = self.qrJSON["name"].string
        newUser.faceBookProfile = self.qrJSON["fb"].string
        newUser.instagramProfile = self.qrJSON["ig"].string
        newUser.snapChatProfile = self.qrJSON["sc"].string
        newUser.phoneNumber = self.qrJSON["pn"].string
        newUser.date = NSDate()
        print(newUser)
        do {
            try(managedObjectContext.save())
            NotificationCenter.default.post(name: .reload, object: nil)
        } catch let err {
            print(err)
        }
    }
 
    func setupBackground() {
        //view.addSubview(visualEffectView)
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
    var addFriendButtonTopAnchor: NSLayoutConstraint?
    
    func setupText() {
        let attributedText = NSMutableAttributedString(string: qrJSON["name"].string!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        nameLabel.attributedText = attributedText
    }
    func setupGraphics() {

        setupText()
        
        view.addSubview(self.profileImage)
        view.addSubview(nameLabel)
        //view.addSubview(addFriendButton)
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
