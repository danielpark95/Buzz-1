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

class PopupController: UIViewController {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        print("init nibName style")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    var qrJSON: JSON = []
    var qrScannerController: QRScannerController = QRScannerController()
    
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
        let image = UIImage(named: "add-friend-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = 1
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        return button
    }()
    

    
    lazy var dismissFriendButton: UIButton = {
        let image = UIImage(named: "dismiss-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = 2
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        return button
    }()
    
    func didSelectButton(sender: UIButton) {
        self.qrScannerController.popupShown = false
        self.dismiss(animated: false, completion: {
            self.setupData(sender.tag)
        })
    }
    func setupData(_ buttonTag: Int) {
        
        // NSCore data functionalities. -- Persist the data when user clicks add friend.
        if (buttonTag == 1) {
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
            } catch let err {
                print(err)
            }
            NotificationCenter.default.post(name: .reload, object: nil)
        }

        
    }
    
    lazy var visualEffectView: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    func setupBackground() {
        view.addSubview(visualEffectView)
        view.addSubview(popupImageView)
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        popupImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 160).isActive = true
    }
    func setupText() {
        nameLabel.numberOfLines = 1
        
        let attributedText = NSMutableAttributedString(string: qrJSON["name"].string!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 26)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
        
        nameLabel.attributedText = attributedText
    }
    func setupGraphics() {

        setupText()
        
        view.addSubview(self.profileImage)
        view.addSubview(nameLabel)
        view.addSubview(addFriendButton)
        view.addSubview(dismissFriendButton)

        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        addFriendButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addFriendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dismissFriendButton.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 10).isActive = true
        dismissFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissFriendButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        dismissFriendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        self.profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
}
