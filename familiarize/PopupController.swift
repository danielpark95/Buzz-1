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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }
    var qrJSON: JSON = []
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let questionLabel: UILabel = {
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
    
    lazy var addFriendButton: UIButton = {
        let image = UIImage(named: "add-friend-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = 1
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectAdd), for: .touchUpInside)
        return button
    }()
    

    
    lazy var dismissFriendButton: UIButton = {
        let image = UIImage(named: "dismiss-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.tag = 2
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectAdd), for: .touchUpInside)
        return button
    }()
    
    func didSelectAdd(sender: UIButton) {
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
            //self.loadData()
        }
        
    }
    
    // This is just a test run on how we can utilize loadData within the contactsVC
    func loadData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        do {
            let userProfiles = try(managedObjectContext.fetch(fetchRequest)) as? [UserProfile]
            print(userProfiles!)
        } catch let err {
            print(err)
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
        popupImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
    }
    func setupGraphics() {

        view.addSubview(questionLabel)
        view.addSubview(addFriendButton)
        view.addSubview(dismissFriendButton)

        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: questionLabel.intrinsicContentSize.height).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant:questionLabel.intrinsicContentSize.width).isActive = true
        
        addFriendButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20).isActive = true
        addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addFriendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        dismissFriendButton.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 10).isActive = true
        dismissFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissFriendButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        dismissFriendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

    }
}
