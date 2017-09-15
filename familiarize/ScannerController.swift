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
    func startCameraScanning()
    func stopCameraScanning()
}

class ScannerController: ScanViewController, ScannerControllerDelegate {
    
    var cameraScanView: ScanView?
    var userProfile: UserProfile?
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
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
        generator.prepare()
        setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        setupViews()
    }
    
    // MARK: ScannerControllerDelegate Functions
    func startCameraScanning() {
        cameraScanView?.start()
    }
    
    func stopCameraScanning() {
        cameraScanView?.stop()
    }
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "cancel-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectBack), for: .touchUpInside)
        return button
    }()
    
    lazy var cameraFrame: UIImageView = {
        return UIManager.makeImage(imageName: "dan_quikkly_circle_frame")
    }()
    
    func didSelectBack() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        tabBarController?.selectedIndex = delegate.previousIndex!
        if let myCameraScanView = self.cameraScanView {
            myCameraScanView.stop()
        }
        // These three steps are vital in memory management and cpu usage.
        // This is because quikkly has made it so fucking weird to turn off the fucking camera.
        // Dismisses the view controller.
        self.dismiss(animated: false, completion: nil)
        // Removes the reference that the parent view controller has to this view controller. (Frees up memory)
        self.removeFromParentViewController()
        // Deletes the whole fucking view controller and initializes a new one.
        NotificationCenter.default.post(name: .removeScanner, object: nil)
    }
    
    func setupViews() {
        view.addSubview(backButton)
        view.addSubview(cameraFrame)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        cameraFrame.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        cameraFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    let scanProfileController = ScanProfileController()
    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        cameraScanView = scanView
      
        // Handle detected scannables
        if let scannable = scannables.first {
            
            // Taptic engine enabled!
            generator.impactOccurred()
            
            // If we dont stop the camera the cpu is going off the fucking charts . . .
            cameraScanView?.stop()
        
            scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.scanProfileController.ScannerControllerDelegate = self
            present(self.scanProfileController, animated: false)
            
            FirebaseManager.getCard(withUniqueID: scannable.value, completionHandler: { card in
                if card.count == 0 {
                    // Perform some animation to show that the quikkly code is invalid.
                    return
                }
                
                // Save the fetched data into CoreData.
                self.userProfile = UserProfile.saveProfile(card, forProfile: .otherUser, withUniqueID: scannable.value)
                
                // Pass on data to scanProfileController
                self.scanProfileController.userProfile = self.userProfile
                self.scanProfileController.setUserName((self.userProfile?.name)!)
                
                // For fetching the profile image picture.
                let socialMedia = SocialMedia(withAppName: (self.userProfile?.profileImageApp)!, withImageName: "", withInputName: (self.userProfile?.profileImageURL)!, withAlreadySet: false)
                
                ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                    if let profileImage = fetchedSocialMediaProfileImages[0].profileImage {
                        self.scanProfileController.setUserProfileImage(profileImage)
                        DiskManager.writeImageDataToLocal(withData: UIImagePNGRepresentation(profileImage)!, withUniqueID: self.userProfile?.uniqueID as! UInt64, withUserProfileSelection: UserProfile.userProfileSelection.otherUser)
                    }
                })
            })
        }
    }
}
