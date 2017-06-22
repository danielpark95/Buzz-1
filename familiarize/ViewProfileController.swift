//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class ViewProfileController: PopupBase {
    var socialMediaButtons: [String : UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    lazy var tintOverlay: UIImageView = {
        let visualEffect = UIManager.makeImage()
        visualEffect.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        visualEffect.frame = self.view.bounds
        return visualEffect
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
    
    override func addToGraphics() {
        createSocialMediaButtons()
        presentSocialMediaButtons()
    }
    
    override func addToBackground() {
        view.addSubview(tintOverlay)
        view.sendSubview(toBack: tintOverlay)
    }
}
