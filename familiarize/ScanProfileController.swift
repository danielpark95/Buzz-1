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
import CoreData
import M13Checkbox

class ScanProfileController: PopupBase {
    var QRScannerDelegate: QRScannerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // The effect for making a blurry background
    lazy var backgroundBlur: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    // Customized checkbox that is supposed to show the user that another user has been added.
    //https://github.com/Marxon13/M13Checkbox
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
    
    
    lazy var viewProfileButton: UIButton = {
        let button = UIManager.makeButton(imageName: "viewprofile-button")
        button.addTarget(self, action: #selector(viewProfileClicked), for: .touchUpInside)
        return button
    }()
    
    // Function handles what happens when user clicks on the "view profile" button.
    // Basically, it unstacks all of the view controllers upto the rootview controller.
    // The root view controller is the tabview controller.
    // And then it selects the first tab of the rootview controller, which is the contacts page.
    // After making the contacts page open, then a notification is passed. The notification
    // tells the contacts page to open up the very first cell and to display the user's information.
    func viewProfileClicked() {
        // Go to different VC
        if self.view.window?.rootViewController as? CustomTabBarController != nil {
            let tabBarController = self.view.window!.rootViewController as! CustomTabBarController
            tabBarController.selectedIndex = 0
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        NotificationCenter.default.post(name: .viewProfile, object: nil)
    }
    
    // When the dismiss button is pressed, the function turns on the QR scanning function back in the
    // QRScannerController view controller. And also pops this view controller from the stack.
    override func dismissClicked() {
        QRScannerDelegate?.commenceCameraScanning()
        self.dismiss(animated: false)
    }
    
    override func addToBackground() {
        view.addSubview(backgroundBlur)
        view.sendSubview(toBack: backgroundBlur)
        view.addSubview(self.checkBox)
    
        self.checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.checkBox.hideBox = true
    }
    
    override func addToGraphics() {
        view.addSubview(self.viewProfileButton)
        
        viewProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewProfileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70).isActive = true
        viewProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewProfileButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        self.checkBox.setCheckState(.checked, animated: true)
    }
}
