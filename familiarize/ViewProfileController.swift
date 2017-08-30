//
//  ViewProfileController.swift
//  familiarize
//
//  Created by Alex Oh on 6/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class ViewProfileController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var socialMediaButtons: [String : UIButton]?
    var socialMediaInputs: [SocialMedia]?
    
    var userProfile: UserProfile?
    let profileImageHeightAndWidth: CGFloat = 150.0
    fileprivate let viewProfileCellId = "viewProfileCellId"
    
    lazy var userSocialMediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 300, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ViewProfileCell.self, forCellWithReuseIdentifier: self.viewProfileCellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePopup()
    }
    
    // This makes the profile image into a circle.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    // MARK: - UI Properties
    
    // Texts gets it textual label from ScannerController
    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    let bioLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    var popupImageView: UIImageView = {
        let imageView = UIManager.makeImage(imageName: "dan_profilepopup_blue")
        let tap = UITapGestureRecognizer()
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        return imageView
    }()
    
    lazy var profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: self.profileImageHeightAndWidth/2)
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_x_button_red")
        // Set the image to have a size of 14px.
        // Then set the overall button to be larger around it -- To increase the hitbox.
        // This is done in the autolayout portion.
        button.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(dismissClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var tintOverlay: UIView = {
        let visualEffect = UIView()
        visualEffect.backgroundColor = UIColor(white: 0, alpha: 0.15)
        visualEffect.alpha = 0
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissClicked)))
        return visualEffect
    }()
    
    func setImage() {
        guard let uniqueID = userProfile?.uniqueID else {
            print("unique id is null")
            return
        }
        guard let profileImage = DiskManager.readImageFromLocal(withUniqueID: uniqueID as! UInt64) else {
            print("file was not able to be retrieved from disk")
            return
        }
        self.profileImage.image = profileImage
    }
    
    func drawMiddleLine() {
        let middleLine = UIManager.makeImage(imageName: "dan_middleline_wide")
        view.addSubview(middleLine)
        middleLine.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor).isActive = true
        middleLine.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor, constant: 40).isActive = true
    }
    
    func setName(){
        var attributedText = NSMutableAttributedString()
        if let name = userProfile?.name {
            attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 26), NSForegroundColorAttributeName: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)])
        }
        nameLabel.attributedText = attributedText
    }
    
    func setBio() {
        var attributedText = NSMutableAttributedString()
        if let bio = userProfile?.bio {
            attributedText = NSMutableAttributedString(string: bio, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)])
        }
        bioLabel.attributedText = attributedText
    }
    
    // MARK: - Animating popup display
    func dismissClicked() {
        self.popupCenterYAnchor?.constant = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tintOverlay.alpha = 0
        }, completion: { _ in
            // After moving the background up to the middle, then load the name and buttons.
            self.dismiss(animated: false)
        })
    }
    
    // Slides up the popup from the bottom of the screen to the middle
    func animatePopup() {
        self.popupCenterYAnchor?.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.tintOverlay.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Setting up views
    var popupCenterYAnchor: NSLayoutConstraint?
    func setupViews() {
        setName()
        setBio()
        setImage()
        
        if let window = UIApplication.shared.keyWindow {
            tintOverlay.frame = window.frame
        }
        view.addSubview(tintOverlay)
        view.addSubview(popupImageView)
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(dismissButton)
        view.addSubview(userSocialMediaCollectionView)
        
        popupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Initially set all the way at the bottom so that it animates up.
        popupCenterYAnchor = self.popupImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        popupCenterYAnchor?.isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: popupImageView.topAnchor, constant: 30).isActive = true
        // Set to 80 --> Then you also have to change the corner radius to 40 ..
        profileImage.heightAnchor.constraint(equalToConstant: profileImageHeightAndWidth).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: profileImageHeightAndWidth).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.width).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.width).isActive = true
        
        dismissButton.centerYAnchor.constraint(equalTo: popupImageView.bottomAnchor, constant: -20).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
  
        userSocialMediaCollectionView.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
        userSocialMediaCollectionView.bottomAnchor.constraint(equalTo: popupImageView.bottomAnchor, constant: 50).isActive = true
        userSocialMediaCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        userSocialMediaCollectionView.widthAnchor.constraint(equalTo: popupImageView.widthAnchor, multiplier: 1.0).isActive = true
//        
//        userSocialMediaCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        userSocialMediaCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
//        userSocialMediaCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        userSocialMediaCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//
//        //drawMiddleLine()
//        createSocialMediaButtons()
//        presentSocialMediaButtons()
    }
    
    
    
    //# MARK: - Body Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = socialMediaInputs?.count {
            return count
        }
        return 0
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 14, 0, 14)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewProfileCellId, for: indexPath) as! ViewProfileCell
        cell.socialMedia = socialMediaInputs?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.tag == collectionViewTag.socialMediaSelectionTableView.rawValue {
//            presentSocialMediaPopup(socialMedia: socialMediaChoices[indexPath.item])
//        } else {
//            if indexPath.item == socialMediaProfileImages.count-2 {
//                let imagePicker: UIImagePickerController = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//                self.present(imagePicker, animated: true)
//            }
//        }
    }
    
    
    
    
    // MARK: - Button Properties
    func buttonLink(_ userURL: String) {
        
        // Lmao, in order to get profile id, just scrape the facebook page again.
        // <meta property="al:ios:url" content="fb://profile/100001667117543">
        let fbURL = URL(string: "fb://profile?id=100001667117543")!
        
        let safariFBURL = URL(string: "https://www.facebook.com/100001667117543")!
        
        if UIApplication.shared.canOpenURL(fbURL)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(fbURL)
            }
            
        } else {
            //redirect to safari because the user doesn't have facebook application
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(safariFBURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(safariFBURL)
            }
        }
    }
    
    func didSelectFB() {
        buttonLink("Kabooya")
    }
    
    func didSelectIG() {
        buttonLink("Kabooya")
    }
    
    func didSelectSC() {
        buttonLink("Kabooya")
    }
    
    func didSelectPN() {
        buttonLink("Kabooya")
    }
    
    // FYI the button should be a facebook button
    lazy var fbButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_facebook_black")
        button.addTarget(self, action: #selector(didSelectFB), for: .touchUpInside)
        return button
    }()
    
    lazy var igButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_instagram_black")
        button.addTarget(self, action: #selector(didSelectIG), for: .touchUpInside)
        return button
    }()
    
    lazy var scButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_snapchat_black")
        button.addTarget(self, action: #selector(didSelectSC), for: .touchUpInside)
        return button
    }()
    
    lazy var pnButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_phone_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var emButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_email_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var inButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_linkedin_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    lazy var soButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_soundcloud_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    lazy var twButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_twitter_black")
        button.addTarget(self, action: #selector(didSelectPN), for: .touchUpInside)
        return button
    }()
    
    func createSocialMediaButtons() {
        socialMediaButtons = [
            "fb": fbButton,
            "ig": igButton,
            "sc": scButton,
            "pn": pnButton,
            "in": emButton,
            "em": inButton,
            "so": soButton,
            "tw": twButton,
        ]
    }
    
    let socialMedia = [
        "faceBookProfile": "fb",
        "instagramProfile": "ig",
        "snapChatProfile": "sc" ,
        "phoneNumber": "pn",
        "email": "em",
        "linkedInProfile": "in",
        "soundCloudProfile": "so",
        "twitterProfile": "tw",
        ]
    
    func presentSocialMediaButtons() {
        var xSpacing: CGFloat = 50
        var ySpacing: CGFloat = 10
        let yConstant: CGFloat = 90
        var shortHandArray = [String]()
        for key in (self.userProfile?.entity.attributesByName.keys)! {
            if (userProfile?.value(forKey: key) != nil && socialMedia[key] != nil) {
                shortHandArray.append(socialMedia[key]!)
            }
        }
        let size = shortHandArray.count
        var count = 0
        
        if size == 1 {
            count = 0
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + yConstant).isActive = true
                count += 1
                if count == 1{
                    break
                }
            }
        } else if size == 2 {
            count = 0
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: ySpacing + yConstant).isActive = true
                xSpacing = xSpacing * (-1)
                count += 1
                if count == 2{
                    break
                }
                
            }
            
        } else if size == 3 {
            count = 0
            ySpacing = 20
            
            
            for shortHand in shortHandArray {
                
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count < 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + yConstant).isActive = true
                }
                
                count += 1
                if count == 3 {
                    break
                }
            }
        } else if size == 4 {
            count = 0
            ySpacing = 20
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count < 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count < 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 3*ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                count += 1
                if count == 4 {
                    break
                }
            }
        } else if size == 5 { //5 looks good
            count = 0
            xSpacing = 80
            ySpacing = 11
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 50).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 50).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                } else if count == 3 {
                    xSpacing = 45
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                } else if count == 4 {
                    xSpacing = 45
                    xSpacing = xSpacing * (-1)
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                }
                count += 1
                if count == 5 {
                    break
                }
            }
        } else if size == 6 { //6 looks good
            count = 0
            xSpacing = 100
            ySpacing = 17
            
            for shortHand in shortHandArray {
                view.addSubview((socialMediaButtons?[shortHand])!)
                (socialMediaButtons?[shortHand])!.heightAnchor.constraint(equalToConstant: 58).isActive = true
                (socialMediaButtons?[shortHand])!.widthAnchor.constraint(equalToConstant: 58).isActive = true
                if count == 0 || count == 2 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 1 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: -ySpacing + yConstant).isActive = true
                } else if count == 3 || count == 5 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor, constant: xSpacing).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                    xSpacing = xSpacing * (-1)
                } else if count == 4 {
                    (socialMediaButtons?[shortHand])!.centerXAnchor.constraint(equalTo: popupImageView.centerXAnchor).isActive = true
                    (socialMediaButtons?[shortHand])!.centerYAnchor.constraint(equalTo: popupImageView.centerYAnchor, constant: 4*ySpacing + yConstant).isActive = true
                }
                count += 1
                if count == 6 {
                    break
                }
            }
        } else {
            //write code for when there are more than 6 linked accounts
        }
    }
}
