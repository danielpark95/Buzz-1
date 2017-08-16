//
//  QRScannerController.swift
//  familiarize
//
//  Created by Alex Oh on 6/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kanna
import CoreData
import Quikkly

protocol ScannerControllerDelegate {
    func startCameraScanning() -> Void
}

class ScannerController: ScanViewController, ScannerControllerDelegate {
    
    var cameraScanView: ScanView?
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This for loop is for removing bullshit from quikkly
        var count = 0
        for v in (view.subviews){
            if count != 0 {
                v.removeFromSuperview()
            }
            count = count + 1
        }
        setupViews()
        print("i have been loaded")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("i am disappear")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("I am appear")
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "cancel-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectBack), for: .touchUpInside)
        return button
    }()
    
    func didSelectBack() {
        //self.dismiss(animated: false, completion: nil)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        tabBarController?.selectedIndex = delegate.previousIndex!
        if let myCameraScanView = self.cameraScanView {
            print("did select back!")
            print("This is the scan view value right before ending \(myCameraScanView)")
            myCameraScanView.stop()
        }
        //self.removeFromParentViewController()
        NotificationCenter.default.post(name: .removeScanner, object: nil)
    }
    
    func setupViews() {
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func startCameraScanning() {
        cameraScanView?.start()
    }
    
    let scanProfileController = ScanProfileController()
    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        cameraScanView = scanView
        print("This is the camera scan view \(cameraScanView)")
        
        // Handle detected scannables
        if let scannable = scannables.first {
            // If we dont stop the camera the cpu is going off the fucking charts . . .
            self.cameraScanView?.stop()
            FirebaseManager.getCard(withUniqueID: scannable.value, completionHandler: { cardJSON in
                
                self.userProfile = UserProfile.saveProfile(cardJSON, forProfile: .otherUser)
                
                // Setting up the controller and animations
                self.scanProfileController.userProfile = self.userProfile
                self.scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.scanProfileController.ScannerControllerDelegate = self
                
                let socialMedia = SocialMedia(withAppName: (self.userProfile?.profileImageApp)!, withImageName: "", withInputName: (self.userProfile?.profileImageURL)!, withAlreadySet: false)
                ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                    let profileImage = fetchedSocialMediaProfileImages[0].profileImage
                    self.scanProfileController.setImage(profileImage!)
                    UserProfile.saveProfileImage(UIImagePNGRepresentation(profileImage!)!, withUserProfile: self.userProfile!)
                })
                self.present(self.scanProfileController, animated: false)
            })
        }
    }
}
