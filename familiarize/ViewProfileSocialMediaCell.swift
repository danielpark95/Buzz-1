//
//  ViewProfileSocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 8/30/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
import UIKit

class ViewProfileSocialMediaCell: UICollectionViewCell {

    private enum buttonType: Int {
        case faceBookProfile
    }
    
    let socialMediaAppNameToEnum: [String : Int] = ["faceBookProfile" : buttonType.faceBookProfile.rawValue]
    
    fileprivate let viewProfileSocialMediaCellId = "viewProfileSocialMediaCellId"
    var socialMedia: SocialMedia? {
        didSet {
            if let imageName = socialMedia?.imageName {
                let image = UIImage(named: imageName)
                socialMediaButton.setImage(image, for: .normal)
                socialMediaButton.tag = socialMediaAppNameToEnum[(socialMedia?.appName)!]!
                setupViews()
            }
        }
    }
    
    lazy var socialMediaButton: UIButton = {
        let button = UIManager.makeButton()
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        addSubview(socialMediaButton)
        socialMediaButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        socialMediaButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        socialMediaButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: - Button Properties
    func buttonClicked() {
        var appURL: URL?
        var safariURL: URL?

        switch socialMediaButton.tag {
        case buttonType.faceBookProfile.rawValue:
            // Lmao, in order to get profile id, just scrape the facebook page again.
            // <meta property="al:ios:url" content="fb://profile/100001667117543">
            appURL = URL(string: "fb://profile?id=\((socialMedia?.inputName)!)")!
            safariURL = URL(string: "https://www.facebook.com/\((socialMedia?.inputName)!)")!
        default: break
        }
        
        // MARK: Open app on phone or load it on safari.
        if let appURL = appURL, let safariURL = safariURL {
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else if UIApplication.shared.canOpenURL(safariURL) {
                //redirect to safari because the user doesn't have facebook application
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(safariURL)
                } else {
                    UIApplication.shared.openURL(safariURL)
                }
            }
        }
    }
}
