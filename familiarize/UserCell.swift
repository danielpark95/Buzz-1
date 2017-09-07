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

class UserCell: UICollectionViewCell {
    
    var fullBrightness: Bool = false
    
    // Padding for moving the user profile picture around
    // The amount of padding removes X amount of padding from the right side.
    // We have to compensate for the lost padding in the view controller by removing the width of the image when applying constraints
    let imageXCoordPadding: CGFloat = -230
    var onQRImage: Bool = true
    var scannableView:ScannableView!
    
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
        let image = UIManager.makeProfileImage(valueOfCornerRadius: 100)
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
        profileImage2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImage2.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupViews() {
        flipCard()
    }
    
    lazy var socialMediaImages: [String: UIImageView] = [
        //temporary icons while we wait for new icons from our graphic designers
        "phoneNumber": UIManager.makeImage(imageName: "dan_phone_black"),
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebook_black"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagram_black"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapchat_black"),
        "linkedInProfile": UIManager.makeImage(imageName: "dan_linkedin_black"),
        "email": UIManager.makeImage(imageName: "dan_email_black"),
        "twitterProfile": UIManager.makeImage(imageName: "dan_twitter_black"),
        "soundCloudProfile": UIManager.makeImage(imageName: "dan_soundcloud_black"),
        ]
    
    //todo: this is old code - change to collectionview
    func presentLinearSocialMediaButtons() {
        var imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        let size = imagesToPresent.count
        var xConstant : CGFloat = 0
        var count = 0
        if size == 1 {
            for image in imagesToPresent {
                self.addSubview(image)
                image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor).isActive = true
                image.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 55).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }
        } else if size == 2 {
            xConstant = 50
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                if count == 0 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: -xConstant).isActive = true
                } else if count == 1 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: xConstant).isActive = true
                }
                image.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 55).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                count += 1
            }
        } else if size == 3 {
            xConstant = 80
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                if count == 0 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: -xConstant).isActive = true
                } else if count == 1 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor).isActive = true
                } else if count == 2 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: xConstant).isActive = true
                }
                image.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 55).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                count += 1
            }
        } else if size == 4 {
            xConstant = 40
            count = 0
            for image in imagesToPresent {
                self.addSubview(image)
                if count == 0 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: -3*xConstant).isActive = true
                } else if count == 1 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: -xConstant).isActive = true
                } else if count == 2 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: xConstant).isActive = true
                } else if count == 3 {
                    image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: 3*xConstant).isActive = true
                }
                image.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 55).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                count += 1
            }
        } else if size == 5 {
            
        } else if size == 6 {
            
        }
    }
    
    func autoLinearSpaceButtons(imagesToPresent: [UIImageView]) {
        var count = 0
        for image in imagesToPresent {
            self.addSubview(image)
            image.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor, constant: 50 ).isActive = true
            image.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 50).isActive = true
            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
            image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    // Helper function to space out social media icons - dan
    func autoAngularSpaceButtons(r: Double, theta1: Double, theta2: Double, imagesToPresent: [UIImageView]){
        var count = 0
        for image in imagesToPresent{
            self.addSubview(image)
            image.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor, constant: CGFloat(r * cos(theta1 + Double(count) * theta2) + 30)).isActive = true
            image.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: CGFloat(r * sin(theta1 + Double(count) * theta2))).isActive = true
            image.heightAnchor.constraint(equalToConstant: 50).isActive = true
            image.widthAnchor.constraint(equalToConstant: 50).isActive = true
            count += 1
        }
    }
    
    // Function to space out social media icons evenly around the profile picture at an equal distance -dan
    func presentAngularSocialMediaButtons() {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        let size = my_imagesToPresent.count
        var my_theta1 = 0.0
        var my_theta2 = 0.0
        let rad = 57.2958
        if size == 1 {
            my_theta1 = 110.0
            my_theta2 = 35.0
        } else if size == 2 {
            my_theta1 = 110.0
            my_theta2 = 35.0
        } else if size == 3 {
            my_theta1 = 110.0
            my_theta2 = 35.0
        } else if size == 4 {
            my_theta1 = 110.0
            my_theta2 = 30.0
        } else if size == 5 {
            my_theta1 = 95.0
            my_theta2 = 25.0
        } else if size == 6 {
            my_theta1 = 80.0
            my_theta2 = 25.0
        } else {
            
        }
        
        autoAngularSpaceButtons(r: 220.0, theta1: my_theta1 / rad, theta2: my_theta2 / rad, imagesToPresent: my_imagesToPresent)
    }
    
    
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
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebook_black_text", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapchat_black_text", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagram_black_text", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitter_black_text", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedin_black_text", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundcloud_black_text", withInputName: "", withAlreadySet: false),
        ]

    func presentProfile() {
        
        addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //profileImage.widthAnchor.constraint(equalToConstant: 350 + (imageXCoordPadding/4)).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        // We have to do imageXCoordPadding/4 because we are removing some pieces on the right side and have to compensate for it.
        
        //Namelabel position upated using NSLayoutConstraint -dan
        addSubview(nameLabel)
        addSubview(bioLabel)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 170).isActive = true
        //nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        //nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        bioLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 230).isActive = true
        //bioLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35).isActive = true
        //bioLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //presentAngularSocialMediaButtons()
        //presentLinearSocialMediaButtons()
        
        
        
        addSubview(appsCollectionView)
        appsCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appsCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        appsCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 470).isActive = true
        appsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100).isActive = true
        appsCollectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        appsCollectionView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        appsCollectionView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var my_imagesToPresent = [UIImageView]()
        for key in (myUserProfile?.entity.attributesByName.keys)! {
            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
            }
        }
        return my_imagesToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        cell.socialMedia = socialMediaChoices[indexPath.item]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        let cellWidth = 332
////        let numberOfCells = (frame.size.width / CGFloat(cellWidth))
////        let edgeInsets = (frame.size.width - (numberOfCells * CGFloat(cellWidth))) / (numberOfCells + 1)
////        
//
//        var leftEdgeInsets : CGFloat = 40
//        var rightEdgeInsets : CGFloat = 40
//        if socialMediaChoices.count == 1 {
//            
//        } else if socialMediaChoices.count == 2 {
//            print("hello")
//        } else if socialMediaChoices.count == 3 {
//            
//        } else if socialMediaChoices.count == 4 {
//            
//        } else if socialMediaChoices.count == 5 {
//            leftEdgeInsets = 40
//            rightEdgeInsets = 40
//        } else if socialMediaChoices.count == 6 {
//            
//        } else {
//            
//        }
//        return UIEdgeInsetsMake(0, leftEdgeInsets, 0, rightEdgeInsets)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        var spacing: CGFloat = 20
//        if socialMediaChoices.count == 1 {
//            
//        } else if socialMediaChoices.count == 2 {
//            spacing = 40
//        } else if socialMediaChoices.count == 3 {
//            
//        } else if socialMediaChoices.count == 4 {
//            
//        } else if socialMediaChoices.count == 5 {
//            
//        } else if socialMediaChoices.count == 6 {
//            
//        } else {
//            
//        }
//        return spacing
//    }
    
    
    
    
    
    
    
   /*
    COMMENT
    */
    
//    fileprivate var sectionInsets: UIEdgeInsets {
//        return .zero
//    }
//    
//    fileprivate var itemsPerRow: CGFloat {
//        //print("count = ", socialMediaChoices.count)
//        var my_imagesToPresent = [UIImageView]()
//        for key in (myUserProfile?.entity.attributesByName.keys)! {
//            if (myUserProfile?.value(forKey: key) != nil && socialMediaImages[key] != nil) {
//                my_imagesToPresent.insert(socialMediaImages[key]!, at: 0)
//            }
//        }
//        print("count = ", my_imagesToPresent.count)
//        
////        if my_imagesToPresent.count > 5 {
////            return 5
////        }
//        return CGFloat(my_imagesToPresent.count)
//    }
    
//    fileprivate var interitemSpace: CGFloat {
//        return 5.0
//    }
//    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var my_itemsPerRow : CGFloat = itemsPerRow
//        if (itemsPerRow > 4 ) {
//            my_itemsPerRow = 4
//        }
//        let sectionPadding = sectionInsets.left * (my_itemsPerRow + 1)
//        let interitemPadding = max(0.0, my_itemsPerRow - 1) * interitemSpace
//        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
//        let widthPerItem = availableWidth / my_itemsPerRow
//        print("width: " , widthPerItem, " height: ", widthPerItem)
//        
        //if (itemsPerRow > 4) {
            return CGSize(width: 80.0, height: 100.0)
        //}
        //return CGSize(width: widthPerItem, height: widthPerItem)
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
        var my_sectionInsets : UIEdgeInsets
        
        if (my_imagesToPresent.count == 1 ) {
            //Good
            my_sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        } else if (my_imagesToPresent.count == 2 ) {
            //Good
            my_sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        } else if (my_imagesToPresent.count == 3 ) {
            //Good
            my_sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        } else if (my_imagesToPresent.count == 4 ) {
            my_sectionInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        } else if (my_imagesToPresent.count == 5 ) {
            my_sectionInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        } else {
            my_sectionInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        }
        
        return my_sectionInsets
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }

    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return interitemSpace
//    }
//    
    
}


class AppCell: UICollectionViewCell {
    
    var socialMedia: SocialMedia? {
        didSet {
//            if let appName = socialMedia?.appName {
//                socialMediaName.text = UIManager.makeRegularHandForDisplay(appName)
//            }
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
        label.font = UIFont(name: "ProximaNovaSoft-Regular", size: 11)
        label.text = label.text?.uppercased()
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(socialMediaImage)
        //addSubview(socialMediaName)
        
        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
