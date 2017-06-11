//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import SwiftyJSON




class ViewProfileController: UIViewController {
    
    var socialMediaButtons: [String : UIButton]?
    var qrJSON: JSON = []
    
    
    lazy var viewProfileButton: UIButton = {
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
                (socialMediaButtons?[key]!)!.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
                (socialMediaButtons?[key]!)!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                (socialMediaButtons?[key]!)!.heightAnchor.constraint(equalToConstant: 40).isActive = true
                (socialMediaButtons?[key]!)!.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }
    }
}
