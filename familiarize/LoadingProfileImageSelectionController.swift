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

class SocialMediaProfileImage: SocialMedia {
    var profileImage: UIImage?
    
    init(copyFrom: SocialMedia, withImage profileImage: UIImage) {
        super.init(copyFrom: copyFrom)
        self.profileImage = profileImage
    }
}

class LoadingProfileImageSelectionController: UIViewController {

    var socialMediaInputs: [SocialMedia]? {
        didSet {
            setupViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        //setupViews()
    }
    
    lazy var activityIndicator1: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 770, height: 770)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator2: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 767, height: 767)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator3: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 764, height: 764)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator4: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 761, height: 761)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    let loadingName: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Fetching profile images (:"
        return label
    }()
    
    
    func setupViews() {
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

        view.addSubview(loadingName)
        loadingName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingName.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingName.widthAnchor.constraint(equalToConstant: loadingName.intrinsicContentSize.width).isActive = true
        loadingName.heightAnchor.constraint(equalToConstant: loadingName.intrinsicContentSize.height).isActive = true
        
        fetchImage()
    }
    
    func fetchImage() {
        if socialMediaInputs != nil {
            for each in socialMediaInputs! {
                print(each.inputName)
            }
            ImageFetchingManager.fetchImages(withSocialMediaInputs: socialMediaInputs!, completionHandler: { fetchedSocialMediaProfileImages in

                let profileImageSelectionController = ProfileImageSelectionController(collectionViewLayout: UPCarouselFlowLayout())
                profileImageSelectionController.socialMediaProfileImages = fetchedSocialMediaProfileImages
                for each in fetchedSocialMediaProfileImages {
                    print(each.inputName)
                }
                self.present(profileImageSelectionController, animated: false, completion: nil)
            })
        }
    }
    
    
}


