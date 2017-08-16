//
//  ProfileImageSelectionController.swift
//  familiarize
//
//  Created by Alex Oh on 7/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Foundation
import UPCarouselFlowLayout
import Alamofire

class SocialMediaProfileImage: SocialMedia {
    var profileImage: UIImage?
    
    init(copyFrom: SocialMedia, withImage profileImage: UIImage) {
        super.init(copyFrom: copyFrom)
        self.profileImage = profileImage
    }
}

class LoadingProfileImageSelectionController: UIViewController {

    var socialMediaInputs: [SocialMedia]?
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        fetchImage()
    }
    
    lazy var activityIndicator1: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 770, height: 770)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor.white
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator2: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 767, height: 767)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor.white
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator3: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 764, height: 764)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor.white
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator4: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 761, height: 761)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor.white
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator5: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 758, height: 758)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor.white
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    let loadingBee: UIImageView = {
        return UIManager.makeImage(imageName: "bee")
    }()
    
    let cancelButton: UIButton = {
       return UIManager.makeButton(imageName: "dan_close_text_white")
    }()
    
    func setupViews() {
        view.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 2/255, alpha: 1.0)
        view.addSubview(activityIndicator1)
        activityIndicator1.center.x = view.center.x
        activityIndicator1.center.y = view.center.y
        view.addSubview(activityIndicator2)
        activityIndicator2.center.x = view.center.x
        activityIndicator2.center.y = view.center.y
        view.addSubview(activityIndicator3)
        activityIndicator3.center.x = view.center.x
        activityIndicator3.center.y = view.center.y
        view.addSubview(activityIndicator4)
        activityIndicator4.center.x = view.center.x
        activityIndicator4.center.y = view.center.y
        view.addSubview(activityIndicator5)
        activityIndicator5.center.x = view.center.x
        activityIndicator5.center.y = view.center.y

        view.addSubview(loadingBee)
        view.bringSubview(toFront: loadingBee)
        loadingBee.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingBee.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        
        view.addSubview(self.cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    

    func cancelButtonClicked() {
        
        // When the skip cancel button is clicked, stop any URL tasks from happening
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
        
        URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
    }
    
    func segueToProfileImageSelectionController(_ socialMediaProfileImages: [SocialMediaProfileImage]) {
        var socialMediaProfileImagesCopy = socialMediaProfileImages
        let defaultSocialMediaInput : SocialMedia = SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false)
        let defaultSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: defaultSocialMediaInput, withImage: UIImage(named: "tjmiller7")!)
        socialMediaProfileImagesCopy.append(defaultSocialMediaProfileImage)
        
        let profileImageSelectionController = ProfileImageSelectionController(collectionViewLayout: UPCarouselFlowLayout())
        profileImageSelectionController.socialMediaProfileImages = socialMediaProfileImagesCopy
        profileImageSelectionController.socialMediaInputs = self.socialMediaInputs
        self.navigationController?.pushViewController(profileImageSelectionController, animated: false)
    }
    
    func fetchImage() {
        let selectedSocialMediaInputsWithPossibleImages = ImageFetchingManager.selectSocialMediaInputsWithPossibleImages(socialMediaInputs!)
        
        // If there are no images to find, then do not animate.
        if selectedSocialMediaInputsWithPossibleImages.count == 0 {
            segueToProfileImageSelectionController([])
        } else {
            setupViews()
            ImageFetchingManager.fetchImages(withSocialMediaInputs: selectedSocialMediaInputsWithPossibleImages, completionHandler: { fetchedSocialMediaProfileImages in
                self.segueToProfileImageSelectionController(fetchedSocialMediaProfileImages)
            })
        }
    }
    
    
}


