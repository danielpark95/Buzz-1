//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData



class ViewProfileController: UIViewController {
    
    var socialMediaButtons: [String : UIButton]?
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createSocialMediaButtons()
        presentSocialMediaButtons()
        
    }
    
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


    lazy var fbButton: UIButton = {
        let image = UIImage(named: "fb-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectFBButton), for: .touchUpInside)
        return button
    }()
    
    lazy var outsideButton: UIButton = {
        let image = UIImage() as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    func dismissClicked() {
        print("taco!!!!s")
        self.dismiss(animated: false)
    }
    
    func didSelectFBButton() {
        
        // Lmao, in order to get profile id, just scrape the facebook page again. 
        // <meta property="al:ios:url" content="fb://profile/100001667117543">
        
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

    func createSocialMediaButtons() {
        socialMediaButtons = [
            "fb" : fbButton
        ]
    }

    func presentSocialMediaButtons() {
        //for (key, subJson):(String, JSON) in qrJSON {
            // Key is key . . . (string)
            // subJson is value . . . (string)
            // Follows key - value concept, like a dictionary.
        //    if (key == "fb" && !((subJson.string?.isEmpty)!)) {
                view.addSubview((socialMediaButtons?["fb"]!)!)
                (socialMediaButtons?["fb"]!)!.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 40).isActive = true
                (socialMediaButtons?["fb"]!)!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                (socialMediaButtons?["fb"]!)!.heightAnchor.constraint(equalToConstant: 40).isActive = true
                (socialMediaButtons?["fb"]!)!.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //    }
       // }
    }
    
    func setupView() {
        
        view.addSubview(outsideButton)
        view.addSubview(popupImageView)
        
        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
        

        view.sendSubview(toBack: outsideButton)
    }
}
