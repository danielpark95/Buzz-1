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

// https://github.com/Marxon13/M13Checkbox
// Checkmark animation

class PopupController: UIViewController {
    
    enum buttonPressed: Int {
        case addFriend = 1
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
    
    lazy var addFriendButton: UIButton = {
        let image = UIImage(named: "addfriend-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = buttonPressed.addFriend.rawValue
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissFriendButton: UIButton = {
        let image = UIImage(named: "dismiss-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = buttonPressed.dismiss.rawValue
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        return button
    }()
    
    lazy var profileButton: UIButton = {
        let image = UIImage(named: "viewprofile-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectProfileButton), for: .touchUpInside)
        return button
    }()
    
    var QRScannerDelegate: QRScannerControllerDelegate?
    func didSelectButton(sender: UIButton) {
        QRScannerDelegate?.commenceCameraScanning()
        self.dismiss(animated: false, completion: {
            self.setupData(sender.tag)
        })
    }
    //var viewProfileButtonHeightConstraint: NSLayoutConstraint?
    
    lazy var fbButton: UIButton = {
        let image = UIImage(named: "fb-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectFBButton), for: .touchUpInside)
        return button
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
//            print(key)
//            print(subJson)
            if (key == "fb" && !((subJson.string?.isEmpty)!)) {
                view.addSubview((socialMediaButtons?[key]!)!)
                (socialMediaButtons?[key]!)!.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 60).isActive = true
                (socialMediaButtons?[key]!)!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                (socialMediaButtons?[key]!)!.heightAnchor.constraint(equalToConstant: 40).isActive = true
                (socialMediaButtons?[key]!)!.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }

        }
        
    }
    
    func setupData(_ buttonTag: Int) {
        
        // NSCore data functionalities. -- Persist the data when user clicks add friend.
        if (buttonTag == buttonPressed.addFriend.rawValue) {
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
    }

    func setupBackground() {
        //view.addSubview(visualEffectView)
        view.addSubview(popupImageView)
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
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
        view.addSubview(addFriendButton)
        view.addSubview(profileButton)
        view.addSubview(dismissFriendButton)

        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 93).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 93).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 15).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        self.addFriendButtonTopAnchor = addFriendButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 80)
        self.addFriendButtonTopAnchor?.isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addFriendButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        profileButton.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 120).isActive = true
        profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
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
