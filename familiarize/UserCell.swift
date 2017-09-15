//
//  UserCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import QRCode
import SwiftyJSON
import UIKit
import Quikkly

var myUserProfileImageCache = NSCache<NSString, UIImage>()

class UserCell:  UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var fullBrightness: Bool = false
    
    // Padding for moving the user profile picture around
    // The amount of padding removes X amount of padding from the right side.
    // We have to compensate for the lost padding in the view controller by removing the width of the image when applying constraints
    let imageXCoordPadding: CGFloat = -230
    var onQRImage: Bool = true
    var scannableView:ScannableView!
    var socialMediaInputs = [SocialMedia]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scannableView = ScannableView()
        NotificationCenter.default.addObserver(self, selector: #selector(manageBrightness), name: .UIScreenBrightnessDidChange, object: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func manageBrightness() {
        if (self.fullBrightness == true) {
            //UIScreen.main.brightness = 1.0
        } else {
            //let delegate = UIApplication.shared.delegate as! AppDelegate
            //UIScreen.main.brightness = delegate.userBrightnessLevel
        }
    }
    
    var myUserProfile: UserProfile? {
        didSet {
            
            let name = NSMutableAttributedString(string: (myUserProfile?.name)!, attributes: [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 25)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
            nameLabel.attributedText = name
            
            let bio = NSMutableAttributedString(string: (myUserProfile?.bio)!, attributes: [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 21)!, NSForegroundColorAttributeName: UIColor(red:144/255.0, green: 135/255.0, blue: 135/255.0, alpha: 1.0)])
            bioLabel.attributedText = bio
            
            // When myUserProfile is set within the UserController as a cell, then load up the required information that the user has.
            createQR(myUserProfile!)
            setupViews()
            
            if let profileImage = myUserProfileImageCache.object(forKey: "\(self.myUserProfile!.uniqueID!)" as NSString) {
                self.profileImage.image = profileImage
            } else {
                
                guard let profileImage = DiskManager.readImageFromLocal(withUniqueID: self.myUserProfile!.uniqueID as! UInt64) else {
                    print("file was not able to be retrieved from disk")
                    return
                }
                
                self.profileImage.image = profileImage
                myUserProfileImageCache.setObject(self.profileImage.image!, forKey: "\(self.myUserProfile!.uniqueID!)" as NSString)

            }
            if let profileImage2 = myUserProfileImageCache.object(forKey: "\(self.myUserProfile!.uniqueID!)" as NSString) {
                self.profileImage2.image = profileImage2
            } else {
                DispatchQueue.global(qos: .userInteractive).async {
                    // if it is not in cache, then call from disk.
                    if let profileImage2 = DiskManager.readImageFromLocal(withUniqueID: self.myUserProfile!.uniqueID as! UInt64) {
                        DispatchQueue.main.async {
                            self.profileImage2.image = profileImage2
                            myUserProfileImageCache.setObject(self.profileImage2.image!, forKey: "\(self.myUserProfile!.uniqueID!)" as NSString)
                        }
                    }
                }
            }

            
            
            
            for key in myUserProfile!.entity.propertiesByName.keys {
                guard let inputName = myUserProfile!.value(forKey: key) else {
                    continue
                }
                if UserProfile.editableMultipleInputUserData.contains(key) {
                    for eachInput in inputName as! [String] {
                        let socialMediaInput = SocialMedia(withAppName: key, withImageName: "dan_\(key)_black", withInputName: eachInput, withAlreadySet: true)
                        //print(socialMediaInput.imageName!)
                        socialMediaInputs.append(socialMediaInput)
                    }
                }
            }
            
        }
    }

    func createQR(_ userProfile: UserProfile) {
        let skin = ScannableSkin()
        skin.backgroundColor = "#FFD705"
        //skin.maskColor = "#2f2f2f"
        skin.dotColor = "#2f2f2f"
        skin.borderColor = "#2f2f2f"
        skin.overlayColor = "#2f2f2f"
        skin.imageUri = ""
        skin.imageFit = .templateDefault
        skin.logoUri = ""
        
        let scannable = Scannable(withValue: userProfile.uniqueID as! UInt64, template: "template0014style3", skin: skin)
        self.scannableView.scannable = scannable
    }
    
    var profileImage: UIImageView = {
        let image = UIManager.makeProfileImage(valueOfCornerRadius: 150)
        return image
    }()
    
    var profileImage2: UIImageView = {
        let image = UIManager.makeProfileImage(valueOfCornerRadius: 97)
        return image
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
    }()
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    func flipCard() {
        
        for v in (self.subviews){
            v.removeFromSuperview()
        }
        
        if onQRImage == true {
            presentProfile()
        } else {
            presentScannableCode()
        }
    }
    
    func presentScannableCode() {
        self.addSubview(self.scannableView)
        self.addSubview(profileImage2)
        scannableView.translatesAutoresizingMaskIntoConstraints = false
        scannableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        scannableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        scannableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scannableView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        
        profileImage2.centerXAnchor.constraint(equalTo: scannableView.centerXAnchor, constant: 0).isActive = true
        profileImage2.centerYAnchor.constraint(equalTo: scannableView.centerYAnchor, constant: 0).isActive = true
        profileImage2.heightAnchor.constraint(equalToConstant: 194).isActive = true
        profileImage2.widthAnchor.constraint(equalToConstant: 194).isActive = true
    }
    
    func setupViews() {
        flipCard()
    }
    
    lazy var socialMediaImages: [String: UIImageView] = [
        //temporary icons while we wait for new icons from our graphic designers
        "phoneNumber": UIManager.makeImage(imageName: "dan_phoneNumber_black"),
        "email": UIManager.makeImage(imageName: "dan_email_black"),
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebookProfile_black"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagramProfile_black"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapChatProfile_black"),
        "twitterProfile": UIManager.makeImage(imageName: "dan_twitterProfile_black"),
        "linkedInProfile": UIManager.makeImage(imageName: "dan_linkedInProfile_black"),
        "soundCloudProfile": UIManager.makeImage(imageName: "dan_soundCloudProfile_black"),
        "venmoProfile": UIManager.makeImage(imageName: "dan_venmoProfile_black"),
        "slackProfile": UIManager.makeImage(imageName: "dan_slackProfile_black"),
        "gitHubProfile": UIManager.makeImage(imageName: "dan_gitHubProfile_black"),
        "spotifyProfile": UIManager.makeImage(imageName: "dan_spotifyProfile_black"),
        "kakaoTalkProfile": UIManager.makeImage(imageName: "dan_kakaoTalkProfile_black"),
        "whatsAppProfile": UIManager.makeImage(imageName: "dan_whatsAppProfile_black"),
        ]
   
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        layout.scrollDirection = .horizontal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        
        //collectionView.collectionViewLayout = columnLayout
        
        
        collectionView.isPagingEnabled = true
        //collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    private let cellId = "appCellId"
    let socialMediaChoices: [SocialMedia] = [
        SocialMedia(withAppName: "phoneNumber", withImageName: "dan_phoneNumber_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "email", withImageName: "dan_email_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebookProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapChatProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagramProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitterProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedInProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundCloudProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "venmoProfile", withImageName: "dan_venmoProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "slackProfile", withImageName: "dan_slackProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "gitHubProfile", withImageName: "dan_gitHubProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "spotifyProfile", withImageName: "dan_spotifyProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "kakaoTalkProfile", withImageName: "dan_kakaoTalkProfile_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "whatsAppProfile", withImageName: "dan_whatsAppProfile_black", withInputName: "", withAlreadySet: false),
        ]
    
    func presentProfile() {
        addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -110).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //profileImage.widthAnchor.constraint(equalToConstant: 350 + (imageXCoordPadding/4)).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        // We have to do imageXCoordPadding/4 because we are removing some pieces on the right side and have to compensate for it.
        
        //Namelabel position upated using NSLayoutConstraint -dan
        addSubview(nameLabel)
        addSubview(bioLabel)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 160).isActive = true
        //nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        //nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        bioLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 220).isActive = true
        //bioLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        //bioLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //presentAngularSocialMediaButtons()
        //presentLinearSocialMediaButtons()
        
        
        
        addSubview(appsCollectionView)
        appsCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appsCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        appsCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 470).isActive = true
        //appsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //appsCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        //appsCollectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        appsCollectionView.widthAnchor.constraint(equalToConstant: 210).isActive = true
        appsCollectionView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialMediaInputs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        print(socialMediaInputs[indexPath.item].imageName)
        cell.socialMedia = socialMediaInputs[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        
        
        if (my_imagesToPresent.count == 2 ) {
            return CGSize(width: 140.0, height: 100)
        }
        if (my_imagesToPresent.count >= 4) {
            return CGSize(width: 80.0, height: 100.0)
        }
        
        return CGSize(width: 120.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }

        if (my_imagesToPresent.count == 1 ) {
            return UIEdgeInsetsMake(0, 127, 0, 127)
        } else if (my_imagesToPresent.count == 2 ) {
            return UIEdgeInsetsMake(0, 42, 0, 42)
        } else if (my_imagesToPresent.count == 3 ) {
            return UIEdgeInsetsMake(0, -1.5, 0, -1.5)
        } else {
            return UIEdgeInsetsMake(0, 10, 0, 10)
        }
        
    }
}


class AppCell: UICollectionViewCell {
    
    var socialMedia: SocialMedia? {
        didSet {
            if let appName = socialMedia?.appName {
                print(appName)
                print(appName.uppercased())
                socialMediaName.text = UIManager.makeRegularHandForDisplay(appName)
            }
            if let imageName = socialMedia?.imageName {
                socialMediaImage.image = UIImage(named: imageName)
            }
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let socialMediaImage: UIImageView = {
        let image = UIManager.makeImage()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let socialMediaName: UILabel = {
        let label = UIManager.makeLabel()
        label.font = UIFont(name: "ProximaNovaSoft-Regular", size: 12)
        print("label.text = " , label.text!)
        print("label.text.uppercased() = " , label.text!.uppercased())
        
        label.text = label.text?.uppercased()
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(socialMediaImage)
        addSubview(socialMediaName)
        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant : -10).isActive = true
        
        
        socialMediaName.centerXAnchor.constraint(equalTo: socialMediaImage.centerXAnchor, constant: 0.5).isActive = true
        socialMediaName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30).isActive = true
        
    }
}
