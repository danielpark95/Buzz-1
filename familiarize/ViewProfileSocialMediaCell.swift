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
        case snapChatProfile
        case instagramProfile
        case linkedInProfile
        case soundCloudProfile
        case twitterProfile
        
        
        case phoneNumber
        case email
        case venmoProfile
        case slackProfile
        case gitHubProfile
        case spotifyProfile
        case kakaoTalkProfile
        case whatsAppProfile
    }
    
    let socialMediaAppNameToEnum: [String : Int] = [
        "phoneNumber" : buttonType.phoneNumber.rawValue,
        "email" : buttonType.phoneNumber.rawValue,
        "faceBookProfile" : buttonType.faceBookProfile.rawValue,
        "snapChatProfile" : buttonType.snapChatProfile.rawValue,
        "instagramProfile" : buttonType.instagramProfile.rawValue,
        "linkedInProfile" : buttonType.linkedInProfile.rawValue,
        "soundCloudProfile" : buttonType.soundCloudProfile.rawValue,
        "twitterProfile" : buttonType.twitterProfile.rawValue,
        "venmoProfile" : buttonType.venmoProfile.rawValue,
        "slackProfile" : buttonType.slackProfile.rawValue,
        "gitHubProfile" : buttonType.gitHubProfile.rawValue,
        "spotifyProfile" : buttonType.gitHubProfile.rawValue,
        "kakaoTalkProfile" : buttonType.kakaoTalkProfile.rawValue,
        "whatsAppProfile" : buttonType.kakaoTalkProfile.rawValue,
        ]
    
    fileprivate let viewProfileSocialMediaCellId = "viewProfileSocialMediaCellId"
    var socialMedia: SocialMedia? {
        didSet {
            if let imageName = socialMedia?.imageName {
                let image = UIImage(named: imageName)
                socialMediaButton.setImage(image, for: .normal)
                if let buttonTag = socialMediaAppNameToEnum[(socialMedia?.appName)!] {
                    socialMediaButton.tag = buttonTag
                }
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

        guard let inputName = socialMedia?.inputName else {
            return
        }
        
        switch socialMediaButton.tag {
            
        case buttonType.faceBookProfile.rawValue:
            // Lmao, in order to get profile id, just scrape the facebook page again.
            // <meta property="al:ios:url" content="fb://profile/100001667117543">
            appURL = URL(string: "fb://profile?id=\(inputName)")
            safariURL = URL(string: "https://www.facebook.com/\(inputName)")
        case buttonType.snapChatProfile.rawValue:
            appURL = URL(string: "snapchat://add/\(inputName)")
            safariURL = URL(string: "https://snapchat.com/add/\(inputName)")
        case buttonType.instagramProfile.rawValue:
            appURL = URL(string: "instagram://user?username=\(inputName)")
            safariURL = URL(string: "https://www.instagram.com/\(inputName)")
        case buttonType.linkedInProfile.rawValue:
            appURL = URL(string: "voyager://in/\(inputName)")
            safariURL = URL(string: "https://www.linkedin.com/in/\(inputName)")
        case buttonType.soundCloudProfile.rawValue:
            // For soundcloud we have to get a specific user id that's parsed from the webpage. 
            // The appurl will be different from the safari url -- in terms of the user input.
            appURL = URL(string: "soundcloud://users:\(inputName)")
            safariURL = URL(string: "https://soundcloud.com/\(inputName)")
        case buttonType.twitterProfile.rawValue:
            appURL = URL(string: "twitter://user?screen_name=\(inputName)")
            safariURL = URL(string: "https://twitter.com/\(inputName)")
            
        
            
            
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
                //redirect to safari because the user doesn't have application
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(safariURL)
                } else {
                    UIApplication.shared.openURL(safariURL)
                }
            }
        }
    }
}
