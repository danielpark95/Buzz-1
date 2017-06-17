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
    override func viewDidAppear(_ animated: Bool) {
        animatePopup()
    }
    
    // Text gets it textual label from QRScannerController
    // This is to just define it
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let popupImageView: UIButton = {
        let button = UIManager.makeButton(imageName: "popup-image")
        button.adjustsImageWhenHighlighted = false
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
    
    lazy var outsideButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var tintOverlay: UIImageView = {
        let image = UIManager.makeImage()
        image.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return image
    }()
    
    func dismissClicked() {
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
    
    var popupCenterYAnchor: NSLayoutConstraint?
    
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func setupView() {
        
        view.addSubview(tintOverlay)
        view.addSubview(outsideButton)
        view.addSubview(popupImageView)
        
        self.tintOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.tintOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.tintOverlay.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.tintOverlay.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        
        self.popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        self.popupCenterYAnchor!.isActive = true
        self.popupImageView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        self.popupImageView.widthAnchor.constraint(equalToConstant: 265).isActive = true
        
        self.outsideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.outsideButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.outsideButton.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        self.outsideButton.widthAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
        
    }
}
