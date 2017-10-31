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
import AVFoundation

protocol ScannerControllerDelegate {
    func startCameraScanning()
    func stopCameraScanning()
}

class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScannerControllerDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode]

    var userProfile: UserProfile?
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var cameraActive: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            generator.prepare()
            setupViews()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        if captureSession != nil {
            captureSession?.stopRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        setupViews()
        if captureSession != nil {
            captureSession?.startRunning()
        }
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
    
    func startCameraScanning() {
        self.cameraActive = true
    }
    
    func stopCameraScanning() {
        captureSession?.stopRunning()
    }
    
    let scanProfileController = ScanProfileController()
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("HOLA")
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if (supportedBarCodes.contains(metadataObj.type) && metadataObj.stringValue != nil && cameraActive == true) {
            cameraActive = false
            let cardUID = UInt64(metadataObj.stringValue) ?? 0
            generator.impactOccurred()
            scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            present(scanProfileController, animated: false)
            FirebaseManager.getCard(withUniqueID: cardUID, completionHandler: { (card, error) in
                guard let card = card else { return }
                if card.count == 0 {
                    return
                }
                
                // Save the fetched data into CoreData.
                self.userProfile = UserProfile.saveProfile(card, forProfile: .otherUser, withUniqueID: cardUID)

                // Pass on data to scanProfileController
                self.scanProfileController.userProfile = self.userProfile
                self.scanProfileController.setUserName((self.userProfile?.name)!)
                self.scanProfileController.scannerControllerDelegate = self

                // For fetching the profile image picture.
                let socialMedia = SocialMedia(withAppName: (self.userProfile?.profileImageApp)!, withImageName: "", withInputName: (self.userProfile?.profileImageURL)!, withAlreadySet: false)

                ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                    if let profileImage = fetchedSocialMediaProfileImages[0].profileImage {
                        self.scanProfileController.setUserProfileImage(profileImage)
                        DiskManager.writeImageDataToLocal(withData: UIImagePNGRepresentation(profileImage)!, withUniqueID: self.userProfile?.uniqueID as! UInt64, withUserProfileSelection: UserProfile.userProfileSelection.otherUser, imageDataType: .profileImage)
                    }
                })
            })
        }
    }
}
