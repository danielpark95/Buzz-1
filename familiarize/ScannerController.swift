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
    
    var cameraActive: Bool = true
    var cameraScanView: ScanView?
    var userProfile: UserProfile?
    
    override init() {
        super.init()
        var count = 0
        for v in (view.subviews){
            if count != 0 {
                v.removeFromSuperview()
            }
            count = count + 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if cameraScanView != nil {
            cameraScanView?.stop()
        }
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cameraScanView != nil {
            cameraScanView?.start()
        }
        self.cameraActive = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        setupViews()
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
        //captureSession?.startRunning()
        cameraActive = true
    }
    
    func stopCameraScanning() {
        if cameraScanView != nil {
            cameraScanView?.stop()
        }
    }
    
    let scanProfileController = ScanProfileController()
    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        cameraScanView = scanView
        
        if cameraActive == true {
            // Handle detected scannables
            if let scannable = scannables.first {
                FirebaseManager.getCard(withUniqueID: scannable.value, completionHandler: { cardJSON in
                    
                    self.userProfile = UserProfile.saveProfile(cardJSON, forProfile: .otherUser)
                    
                    // Setting up the controller and animations
                    self.scanProfileController.userProfile = self.userProfile
                    self.scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    self.scanProfileController.ScannerControllerDelegate = self
                    
                    
                    /*
 
 
 ImageFetchingManager.fetchImages(withSocialMediaInputs: socialMediaInputs!, completionHandler: { fetchedSocialMediaProfileImages in
 let profileImageSelectionController = ProfileImageSelectionController(collectionViewLayout: UPCarouselFlowLayout())
 profileImageSelectionController.socialMediaProfileImages = fetchedSocialMediaProfileImages
 profileImageSelectionController.socialMediaInputs = self.socialMediaInputs
 self.navigationController?.pushViewController(profileI
 */
                    
                    let socialMedia = SocialMedia(withAppName: (self.userProfile?.profileImageApp)!, withImageName: "", withInputName: (self.userProfile?.profileImageURL)!, withAlreadySet: false)
                    ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                        let profileImage = fetchedSocialMediaProfileImages[0].profileImage
                        UserProfile.saveProfileImage(UIImagePNGRepresentation(profileImage!)!, withUserProfile: self.userProfile!)
                        self.scanProfileController.setImage()
                        
                    })
                    
                    
                    self.present(self.scanProfileController, animated: false)
                    
                    self.cameraActive = false
                    
                    // If we dont stop the camera the cpu is going off the fucking charts . . .
                    //self.cameraScanView?.stop()
                    
                })
            }
        }
    }
    
    // MUST REFACTOR ALL THESE CODES FOR LATER USE. PUT ALL OF THESE CALLS INTO IMAGEFETCHINGMANAGER!!
    
    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    
    func scrapeSocialMedia(_ scanProfileController: ScanProfileController ) {
        
        let profileImageApp = userProfile?.profileImageApp
        print("The profile image app is: \(profileImageApp)" )
        if (profileImageApp == "fb") {
            // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
            Alamofire.request("https://www.facebook.com/" + (self.userProfile?.faceBookProfile)!).responseString { response in
                if let html = response.result.value {
                    self.parseHTML(html: html, scanProfileController: scanProfileController)
                }
            }
        } else if (profileImageApp == "df") { // For handling images that were uploaded to the firebase server.
            
            let profileImageURL = userProfile?.profileImageURL
            let formattedProfileImageURL  = URL(string: profileImageURL!)
            
            URLSession.shared.dataTask(with: formattedProfileImageURL!, completionHandler: { data, response, error in
                
                if let profileImageData = data {
                    DispatchQueue.main.async {
                        UserProfile.saveProfileImage(profileImageData as Data, withUserProfile: self.userProfile!)
                        scanProfileController.setImage()
                    }
                }
            }).resume()
        }
    }
    
    
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    func parseHTML(html: String, scanProfileController: ScanProfileController) {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for show in doc.css("img[class^='profilePic img']") {
                let url = NSURL(string: show["src"]!)!
                let profileImage:NSData? = NSData(contentsOf: url as URL)
                UserProfile.saveProfileImage(profileImage! as Data, withUserProfile: self.userProfile!)
                scanProfileController.setImage()
            }
        }
    }
}


/*
class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScannerControllerDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var cameraActive: Bool = true
    var userProfile: UserProfile?
    
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
        if captureSession != nil {
            captureSession?.stopRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if captureSession != nil {
            captureSession?.startRunning()
        }
        self.cameraActive = true
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
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
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            setupViews()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "cancel-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectDelete), for: .touchUpInside)
        return button
    }()
    
    func didSelectDelete() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        tabBarController?.selectedIndex = delegate.previousIndex!
    }
    
    func setupViews() {
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    
    func verifyAndSave(_ qrCode: String) -> Bool {
        // TODO: Before even moving on, this function should verify that the qr code's JSON is in the format that we need it in.
        
        let data = qrCode.data(using: .utf8)
        self.userProfile = UserProfile.saveProfile(JSON(data!), forProfile: .otherUser)
        return true
    }
    
    func startCameraScanning() {
        //captureSession?.startRunning()
        self.cameraActive = true
    }
    
    func stopCameraScanning() {
        captureSession?.stopRunning()
    }
    
    let scanProfileController = ScanProfileController()
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) && self.cameraActive == true {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if (metadataObj.stringValue != nil  && verifyAndSave(metadataObj.stringValue)) {
                
                // Setting up the controller and animations
                scanProfileController.userProfile = self.userProfile
                scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                scanProfileController.ScannerControllerDelegate = self
                
                self.scrapeSocialMedia(scanProfileController)
                
                self.present(scanProfileController, animated: false)
                
                self.cameraActive = false
            }
        }
    }
    
    // MUST REFACTOR ALL THESE CODES FOR LATER USE. PUT ALL OF THESE CALLS INTO IMAGEFETCHINGMANAGER!!
    
    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    func scrapeSocialMedia(_ scanProfileController: ScanProfileController) {
        
        let profileImageApp = userProfile?.profileImageApp
        print("The profile image app is: \(profileImageApp)" )
        if (profileImageApp == "fb") {
            // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
            Alamofire.request("https://www.facebook.com/" + (self.userProfile?.faceBookProfile)!).responseString { response in
                if let html = response.result.value {
                    self.parseHTML(html: html, scanProfileController: scanProfileController)
                }
            }
        } else if (profileImageApp == "df") { // For handling images that were uploaded to the firebase server.

            let profileImageURL = userProfile?.profileImageURL
            let formattedProfileImageURL  = URL(string: profileImageURL!)
            
            URLSession.shared.dataTask(with: formattedProfileImageURL!, completionHandler: { data, response, error in
                
                if let profileImageData = data {
                    DispatchQueue.main.async {
                        UserProfile.saveProfileImage(profileImageData as Data, withUserProfile: self.userProfile!)
                        scanProfileController.setImage()
                    }
                }
            }).resume()
        }
    }
    
    
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    func parseHTML(html: String, scanProfileController: ScanProfileController) {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for show in doc.css("img[class^='profilePic img']") {
                let url = NSURL(string: show["src"]!)!
                let profileImage:NSData? = NSData(contentsOf: url as URL)
                UserProfile.saveProfileImage(profileImage! as Data, withUserProfile: self.userProfile!)
                scanProfileController.setImage()
            }
        }
    }
}
*/
