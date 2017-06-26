//
//  QRScannerController.swift
//  familiarize
//
//  Created by Alex Oh on 6/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire
import Kanna
import CoreData

protocol QRScannerControllerDelegate {
    func commenceCameraScanning()
}

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, QRScannerControllerDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var qrJSON: JSON = []
    var cameraActive: Bool = true
    var userProfile: UserProfile?
    
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        let image = UIImage(named: "back-button") as UIImage?
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyAndSave(_ qrCode: String) -> Bool {
        // TODO: Before even moving on, this function should verify that the qr code's JSON is in the format that we need it in.
        
        let data = qrCode.data(using: .utf8)
        self.userProfile = UserProfile.saveData(JSON(data!))
        return true
        
    }
    
    func commenceCameraScanning() {
        self.cameraActive = true
    }
    
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
                let scanProfileController = ScanProfileController()
                scanProfileController.userProfile = self.userProfile
                scanProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                scanProfileController.QRScannerDelegate = self
                
                self.scrapeSocialMedia(scanProfileController)
                
                self.present(scanProfileController, animated: false)
                self.cameraActive = false
                
            }
        }
    }
    
    // Purpose is to grab an html page for each respective social media account so that we can find their social media images.
    func scrapeSocialMedia(_ scanProfileController: ScanProfileController) {
        // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
        Alamofire.request("https://www.facebook.com/" + (self.userProfile?.faceBookProfile)!).responseString { response in
            //Alamofire.request("https://www.facebook.com/" + "100004830645669").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html, scanProfileController: scanProfileController)
            }
        }
    }
    
    // This receives a whole html page and parses through the html document and go search for the link that holds the facebook image.
    func parseHTML(html: String, scanProfileController: ScanProfileController) {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for show in doc.css("img[class^='profilePic img']") {
                let url = NSURL(string: show["src"]!)!
                print(show["src"]!)
                let profileImage:NSData? = NSData(contentsOf: url as URL)
                UserProfile.saveProfileImage(profileImage! as Data, userObject: self.userProfile!)
            }
        }
    }
}



////
////  FamiliarizeController.swift
////  familiarize
////
////  Created by Alex Oh on 5/31/17.
////  Copyright © 2017 nosleep. All rights reserved.
////
//
//import UIKit
//import CoreData
//import SwiftyJSON
//
//class FamiliarizeController: UIViewController {
//
//    private let cellId = "cellId"
//    
//    override func viewWillAppear(_ animated: Bool) {
//        let cameraController = QRScannerController()
//        self.present(cameraController, animated: false)
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
////        navigationItem.title = ""
////        self.automaticallyAdjustsScrollViewInsets = false
////        
////        setupView()
////        setupCollectionView()
////        didSelectCamera()
//        
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        print("taco")
//    }
//    
////    lazy var cameraButton: UIButton = {
////        let image = UIImage(named: "dan_camera") as UIImage?
////        var button = UIButton(type: .custom) as UIButton
////        button.setImage(image, for: .normal)
////        button.translatesAutoresizingMaskIntoConstraints = false
////        button.addTarget(self, action: #selector(didSelectCamera), for: .touchUpInside)
////        return button
////    }()
////    
////    func didSelectCamera() {
////        let cameraController = QRScannerController()
////        self.present(cameraController, animated: false)
////    }
////    
////    func setupView() {
////        // Add the dots that animate your current location with the qrcodes into the view
////        view.addSubview(pageControl)
////        view.addSubview(cameraButton)
////        
////        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
////        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
////        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
////        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
////        
////        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
////        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
////        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
////    }
////    
////    func setupCollectionView() {
////        collectionView?.showsHorizontalScrollIndicator = false
////        collectionView?.backgroundColor = UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
////        collectionView?.register(FamiliarizeCell.self, forCellWithReuseIdentifier: self.cellId)
////        
////        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
////            flowLayout.scrollDirection = .horizontal
////        }
////        collectionView?.isPagingEnabled = true
////    }
////    
////    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
////    let pageControl: UIPageControl = {
////        let pc = UIPageControl()
////        //pc.pageIndicatorTintColor = .lightGray
////        pc.numberOfPages = 3 // Change the number of pages to something else after you get like the coredata working
////        pc.currentPageIndicatorTintColor = UIColor.white
////        pc.translatesAutoresizingMaskIntoConstraints = false
////        return pc
////    }()
////    
////    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
////        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
////        pageControl.currentPage = pageNumber
////    }
////    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return 3 // Change the number of pages to something else after you get like the coredata working
////    }
////    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
////    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return self.collectionView!.frame.size;
////    }
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return 0
////    }
//    
//    
//}
//
