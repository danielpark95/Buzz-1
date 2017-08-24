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
    func stopCameraScanning() -> Void
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
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    let scanProfileController = ScanProfileController()
    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        cameraScanView = scanView
      
        // Handle detected scannables
        if let scannable = scannables.first {
            // If we dont stop the camera the cpu is going off the fucking charts . . .
            cameraScanView?.stop()
        
            scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.scanProfileController.ScannerControllerDelegate = self
            present(self.scanProfileController, animated: false)
            
            FirebaseManager.getCard(withUniqueID: scannable.value, completionHandler: { cardJSON in
                // Save the fetched data into CoreData.
                self.userProfile = UserProfile.saveProfile(cardJSON, forProfile: .otherUser)
                
                // Pass on data to scanProfileController
                self.scanProfileController.userProfile = self.userProfile
                self.scanProfileController.setUserName((self.userProfile?.name)!)
                                                                                       
                // For fetching the profile image picture.
                let socialMedia = SocialMedia(withAppName: (self.userProfile?.profileImageApp)!, withImageName: "", withInputName: (self.userProfile?.profileImageURL)!, withAlreadySet: false)
                ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                    let profileImage = fetchedSocialMediaProfileImages[0].profileImage
                    self.scanProfileController.setUserProfileImage(profileImage!)
                    UserProfile.saveProfileImage(UIImagePNGRepresentation(profileImage!)!, withUserProfile: self.userProfile!)
                })
            })
        }
    }
}
