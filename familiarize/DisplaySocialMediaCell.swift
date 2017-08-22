////
////  DisplaySocialMediaCell.swift
////  familiarize
////
////  Created by Daniel Park on 8/15/17.
////  Copyright © 2017 nosleep. All rights reserved.
////
//import UIKit
//
//class DisplaySocialMediaCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    
//    var newCardControllerDelegate: NewCardControllerDelegate?
//    
//    private let cellId = "cellId"
//    
//    let socialMediaChoices: [DisplaySocialMedia] = [
//        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebook_black"),
//        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapchat_black"),
//        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagram_black"),
//        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitter_black"),
//        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedin_black"),
//        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundcloud_black"),
//        ]
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let socialMediaCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.alwaysBounceHorizontal = false
//        
//        return collectionView
//    }()
//    
//    func setupViews() {
//        backgroundColor = UIColor.white
//        
//        addSubview(socialMediaCollectionView)
//        
//        socialMediaCollectionView.dataSource = self
//        socialMediaCollectionView.delegate = self
//        socialMediaCollectionView.register(SocialMediaCell.self, forCellWithReuseIdentifier: cellId)
//        
//        socialMediaCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        socialMediaCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        socialMediaCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        socialMediaCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return socialMediaChoices.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SocialMediaCell
//        cell.socialMedia = socialMediaChoices[indexPath.item]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 50, height: frame.height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 14, 0, 14)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.newCardControllerDelegate?.presentSocialMediaPopup(socialMedia: socialMediaChoices[indexPath.item])
//    }
//}
//
//class DisplaySocialMedia: NSObject {
//    var imageName: String?
//    var appName: String?
//    
//    init(withAppName appName: String, withImageName imageName: String, withInputName inputName: String, withAlreadySet isSet: Bool) {
//        self.imageName = imageName
//        self.appName = appName
//    }
//    
//    init(copyFrom: DisplaySocialMedia) {
//        self.imageName = copyFrom.imageName
//        self.appName = copyFrom.appName
//    }
//}
//
//class SocialMediaCell: UICollectionViewCell {
//    
//    var socialMedia: DisplaySocialMedia? {
//        didSet {
//            if let appName = socialMedia?.appName {
//                socialMediaName.text = UIManager.makeRegularHandForDisplay(appName)
//            }
//            if let imageName = socialMedia?.imageName {
//                socialMediaImage.image = UIImage(named: imageName)
//            }
//            setupViews()
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let socialMediaImage: UIImageView = {
//        let image = UIManager.makeImage()
//        image.contentMode = .scaleAspectFill
//        return image
//    }()
//    
//    func setupViews() {
//        backgroundColor = UIColor.white
//        addSubview(socialMediaImage)
//        //addSubview(socialMediaName)
//        
//        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        socialMediaImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        socialMediaImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        
////        socialMediaName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
////        socialMediaName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
////        socialMediaName.heightAnchor.constraint(equalToConstant: socialMediaName.intrinsicContentSize.height).isActive = true
////        socialMediaName.widthAnchor.constraint(equalToConstant: socialMediaName.intrinsicContentSize.width).isActive = true
//    }
//}
//
