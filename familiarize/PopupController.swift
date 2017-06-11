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
    var socialMediaButtons: [String : UIButton]?
    
    
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
    
//    lazy var addFriendButton: UIButton = {
//        let image = UIImage(named: "addfriend-button") as UIImage?
//        var button = UIButton(type: .custom) as UIButton
//        button.tag = buttonTag.addFriend.rawValue
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
//        return button
//    }()
    

    
    lazy var dismissFriendButton: UIButton = {
        self.makeButton(imageName: "dismiss-button", tag: buttonTag.dismiss.rawValue)
    }()
    
    lazy var viewProfileButton: UIButton = {
        self.makeButton(imageName: "viewprofile-button", tag: buttonTag.profile.rawValue)
    }()
    
    lazy var profileButton: UIButton = {
        let image = UIImage(named: "viewprofile-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectProfileButton), for: .touchUpInside)
        return button
    }()
    
    
    lazy var fbButton: UIButton = {
        let image = UIImage(named: "fb-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectFBButton), for: .touchUpInside)
        return button
    }()
    
    func makeButton(imageName: String, tag: Int) -> UIButton {
        let image = UIImage(named: imageName) as UIImage?
        var button = UIButton(type: .custom) as UIButton
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
            self.dismiss(animated: false, completion: {
                //self.setupData(sender.tag)
            })
        } else if (sender.tag == buttonTag.profile.rawValue) {
            // Code for going back to the viewprofile
        }
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
    
    func didSelectFBButton() {
        
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
    
    func didSelectProfileButton() {
        
        
        self.profileButton.removeFromSuperview()
        
        self.addFriendButtonTopAnchor?.constant += 40
        view.layoutIfNeeded()
        createSocialMediaButtons()
        presentSocialMediaButtons()
        
    }
    
    func createSocialMediaButtons() {
        socialMediaButtons = [
            "fb" : fbButton
        ]
    }
    
    func presentSocialMediaButtons() {

        for (key, subJson):(String, JSON) in qrJSON {
            // Key is key . . . (string)
            // subJson is value . . . (string)
            // Follows key - value concept, like a dictionary.
            if (key == "fb" && !((subJson.string?.isEmpty)!)) {
                view.addSubview((socialMediaButtons?[key]!)!)
                (socialMediaButtons?[key]!)!.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 60).isActive = true
                (socialMediaButtons?[key]!)!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                (socialMediaButtons?[key]!)!.heightAnchor.constraint(equalToConstant: 40).isActive = true
                (socialMediaButtons?[key]!)!.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }

        }
    }
    
// Used when add friend is pressed.
    
//    func setupData(_ buttonTag: Int) {
//        
//        // NSCore data functionalities. -- Persist the data when user clicks add friend.
//        if (buttonTag == buttonPressed.addFriend.rawValue) {
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            let managedObjectContext = delegate.persistentContainer.viewContext
//            let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: managedObjectContext) as! UserProfile
//            newUser.name = self.qrJSON["name"].string
//            newUser.faceBookProfile = self.qrJSON["fb"].string
//            newUser.instagramProfile = self.qrJSON["ig"].string
//            newUser.snapChatProfile = self.qrJSON["sc"].string
//            newUser.phoneNumber = self.qrJSON["pn"].string
//            newUser.date = NSDate()
//            print(newUser)
//            do {
//                try(managedObjectContext.save())
//                NotificationCenter.default.post(name: .reload, object: nil)
//            } catch let err {
//                print(err)
//            }
//        }
//    }

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
        
//        self.addFriendButtonTopAnchor = addFriendButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 80)
//        self.addFriendButtonTopAnchor?.isActive = true
//        addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        addFriendButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
//        
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
