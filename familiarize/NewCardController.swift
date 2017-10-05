//
//  NewCardController.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import UPCarouselFlowLayout
import AAPhotoCircleCrop

protocol NewCardControllerDelegate {
    func presentSocialMediaPopup(socialMedia: SocialMedia) -> Void
    func addSocialMediaInput(socialMedia: SocialMedia) -> Void
}

class SocialMediaProfileImage: SocialMedia {
    var profileImage: UIImage?
    
    init(copyFrom: SocialMedia, withImage profileImage: UIImage) {
        super.init(copyFrom: copyFrom)
        self.profileImage = profileImage
    }
}

class NewCardController: UIViewController, NewCardControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AACircleCropViewControllerDelegate {
    
    private let profileImageSelectionCellId = "profileImageSelectionCellId"
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    
    private enum collectionViewTag: Int {
        case profileImageSelectionTableView
        case socialMediaSelectionTableView
    }
    
    var editingUserProfile: UserProfile?

    let socialMediaChoices: [SocialMedia] = [
        SocialMedia(withAppName: "phoneNumber", withImageName: "dan_phoneNumber_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "email", withImageName: "dan_email_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_faceBookProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapChatProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagramProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitterProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedInProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundCloudProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "venmoProfile", withImageName: "dan_venmoProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "slackProfile", withImageName: "dan_slackProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "gitHubProfile", withImageName: "dan_gitHubProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "spotifyProfile", withImageName: "dan_spotifyProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "kakaoTalkProfile", withImageName: "dan_kakaoTalkProfile_add", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "whatsAppProfile", withImageName: "dan_whatsAppProfile_add", withInputName: "", withAlreadySet: false),
        ]
    
    var socialMediaProfileImages: [SocialMediaProfileImage] = [
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "man1", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "man1")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "man2", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "man2")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "man3", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "man3")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "woman1", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "woman1")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "woman2", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "woman2")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "woman3", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "woman3")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "dan_addprofileimage_orange", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "dan_addprofileimage_orange")!)
    ]
    
    var socialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "dan_name_black", withInputName: "", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "dan_bio_black", withInputName: "", withAlreadySet: true)
    ]
 
    lazy var socialMediaSelectionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialMediaSelectedContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialMediaSelectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cellSize = CGSize(width: 70, height: 65)
        layout.itemSize = cellSize
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SocialMediaSelectionCell.self, forCellWithReuseIdentifier: self.socialMediaSelectionCellId)
        
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        collectionView.tag = collectionViewTag.socialMediaSelectionTableView.rawValue
        return collectionView
    }()

    lazy var socialMediaSelectedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.socialMediaSelectedCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var deleteButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIManager.makeTextButton(buttonText: "Delete Card", color: .red)
        button.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        button.backgroundColor = .white
        button.tintColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var profileImageSelectionCollectionView: UICollectionView = {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -100)
        // If the size is not set to 400|400, then the first cell is not centered.
        layout.itemSize = CGSize(width: 400, height: 400)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileImageSelectionCell.self, forCellWithReuseIdentifier: self.profileImageSelectionCellId)
        collectionView.tag = collectionViewTag.profileImageSelectionTableView.rawValue
        return collectionView
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    }()
    
    var currentPositionOfSelectionContainer: CGFloat = 0
    var currentPositionOfSelectedContainer: CGFloat = 0
    var currentPositionOfProfileImage: CGFloat = 0
    var currentPositionOfDeleteButton: CGFloat = 0
    var scrolledUp: Bool = false
    func handlePan(_ sender: UIPanGestureRecognizer) {
        // TODO: Utilize the velocity of the swipe and the point.y to determine if the bottom/top portion should be shown.
        
        let point = sender.translation(in: view)
        socialMediaSelectionContainerView.center = CGPoint(x: socialMediaSelectionContainerView.center.x, y: currentPositionOfSelectionContainer + point.y)
        socialMediaSelectedContainerView.center = CGPoint(x: socialMediaSelectedContainerView.center.x, y: currentPositionOfSelectedContainer + point.y)
        profileImageSelectionCollectionView.center = CGPoint(x: profileImageSelectionCollectionView.center.x, y: currentPositionOfProfileImage + point.y)
        deleteButtonContainerView.center = CGPoint(x: deleteButtonContainerView.center.x, y: currentPositionOfDeleteButton + point.y)
        
        switch sender.state {
        case .ended:
            if scrolledUp == false {
                if point.y > -20 {
                    backToOriginalPosition()
                } else {
                    toTopPosition()
                }
            } else if scrolledUp == true{
                if point.y > 20 {
                    backToOriginalPosition()
                } else {
                    toTopPosition()
                }
            }
            scrolledUp = !scrolledUp
        default: break
        }
    }
    
    func backToOriginalPosition() {
        var selectedContainerOffset: CGFloat = 0
        if editingUserProfile != nil {
            selectedContainerOffset = 410
        } else {
            selectedContainerOffset = 440
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.socialMediaSelectionContainerView.center = CGPoint(x: self.socialMediaSelectionContainerView.center.x, y: self.view.center.y + 165)
            self.socialMediaSelectedContainerView.center = CGPoint(x: self.socialMediaSelectedContainerView.center.x, y: self.view.center.y + selectedContainerOffset)
            self.profileImageSelectionCollectionView.center = CGPoint(x: self.profileImageSelectionCollectionView.center.x, y: self.view.center.y - 50)
            self.deleteButtonContainerView.center = CGPoint(x: self.deleteButtonContainerView.center.x, y: self.view.center.y + 500)
        })
        currentPositionOfSelectionContainer = view.center.y + 165
        currentPositionOfSelectedContainer = view.center.y + selectedContainerOffset
        currentPositionOfProfileImage = view.center.y - 50
        currentPositionOfDeleteButton = view.center.y + 500
    }
    
    func toTopPosition() {
        var selectedContainerOffset: CGFloat = 0
        if editingUserProfile != nil {
            selectedContainerOffset = 390
        } else {
            selectedContainerOffset = 420
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.socialMediaSelectionContainerView.center = CGPoint(x: self.socialMediaSelectionContainerView.center.x, y: 140)
            self.socialMediaSelectedContainerView.center = CGPoint(x: self.socialMediaSelectedContainerView.center.x, y: selectedContainerOffset)
            self.profileImageSelectionCollectionView.center = CGPoint(x: self.profileImageSelectionCollectionView.center.x, y: -55)
            self.deleteButtonContainerView.center = CGPoint(x: self.deleteButtonContainerView.center.x, y: self.view.frame.height - 40)
        })
        currentPositionOfSelectionContainer = 140
        currentPositionOfSelectedContainer = selectedContainerOffset
        currentPositionOfProfileImage = -55
        currentPositionOfDeleteButton = view.frame.height - 40
    }
    
    func deleteClicked() {
        guard let userProfile = editingUserProfile else { return }
        DiskManager.deleteImageFromLocal(withUniqueID: userProfile.uniqueID as! UInt64)
        FirebaseManager.deleteCard(uniqueID: userProfile.uniqueID!.uint64Value)
        UserProfile.deleteProfile(user: userProfile)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20), NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)]
        if editingUserProfile != nil {
            setupEditingView()
        } else {
            setupView()
        }
        setupNavBarButton()
    }
    
    func setupEditingView() {
        
        // Mr. Pan is added to the whole view. So when you touch anything on the view,
        // it calls Mrs. PanHandle
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.addSubview(profileImageSelectionCollectionView)
        view.addSubview(socialMediaSelectionContainerView)
        view.addSubview(socialMediaSelectedContainerView)
        view.addSubview(deleteButtonContainerView)
        
        socialMediaSelectionContainerView.addSubview(socialMediaSelectionCollectionView)
        socialMediaSelectedContainerView.addSubview(socialMediaSelectedTableView)
        deleteButtonContainerView.addSubview(deleteButton)
        
        // Profile Image View
        currentPositionOfProfileImage = view.center.y - 50
        
        profileImageSelectionCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageSelectionCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileImageSelectionCollectionView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        profileImageSelectionCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        // Selection View
        currentPositionOfSelectionContainer = view.center.y + 165
        
        socialMediaSelectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectionContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectionContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        socialMediaSelectionContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 165).isActive = true
        
        socialMediaSelectionCollectionView.bottomAnchor.constraint(equalTo: socialMediaSelectionContainerView.bottomAnchor).isActive = true
        socialMediaSelectionCollectionView.leftAnchor.constraint(equalTo: socialMediaSelectionContainerView.leftAnchor).isActive = true
        socialMediaSelectionCollectionView.rightAnchor.constraint(equalTo: socialMediaSelectionContainerView.rightAnchor).isActive = true
        socialMediaSelectionCollectionView.topAnchor.constraint(equalTo: socialMediaSelectionContainerView.topAnchor).isActive = true
        
        // Selected View
        currentPositionOfSelectedContainer = view.center.y + 410
        
        socialMediaSelectedContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectedContainerView.heightAnchor.constraint(equalToConstant: 405).isActive = true
        socialMediaSelectedContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 410).isActive = true
        
        socialMediaSelectedTableView.bottomAnchor.constraint(equalTo: socialMediaSelectedContainerView.bottomAnchor).isActive = true
        socialMediaSelectedTableView.leftAnchor.constraint(equalTo: socialMediaSelectedContainerView.leftAnchor).isActive = true
        socialMediaSelectedTableView.rightAnchor.constraint(equalTo: socialMediaSelectedContainerView.rightAnchor).isActive = true
        socialMediaSelectedTableView.topAnchor.constraint(equalTo: socialMediaSelectedContainerView.topAnchor).isActive = true
        
        //Delete Button
        currentPositionOfDeleteButton = view.center.y + 500
        
        deleteButtonContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButtonContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        deleteButtonContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButtonContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 500).isActive = true
        
        deleteButton.bottomAnchor.constraint(equalTo: deleteButtonContainerView.bottomAnchor).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: deleteButtonContainerView.leftAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: deleteButtonContainerView.rightAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: deleteButtonContainerView.topAnchor).isActive = true
    }
    
 
    func setupView() {
        
        // Mr. Pan is added to the whole view. So when you touch anything on the view,
        // it calls Mrs. PanHandle
        view.addGestureRecognizer(panGestureRecognizer)

        view.addSubview(profileImageSelectionCollectionView)
        view.addSubview(socialMediaSelectionContainerView)
        view.addSubview(socialMediaSelectedContainerView)
        
        socialMediaSelectionContainerView.addSubview(socialMediaSelectionCollectionView)
        socialMediaSelectedContainerView.addSubview(socialMediaSelectedTableView)
        
        // Profile Image View
        currentPositionOfProfileImage = view.center.y - 50
        
        profileImageSelectionCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageSelectionCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileImageSelectionCollectionView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        profileImageSelectionCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true

        // Selection View
        currentPositionOfSelectionContainer = view.center.y + 165
        
        socialMediaSelectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectionContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectionContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        socialMediaSelectionContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 165).isActive = true
        
        socialMediaSelectionCollectionView.bottomAnchor.constraint(equalTo: socialMediaSelectionContainerView.bottomAnchor).isActive = true
        socialMediaSelectionCollectionView.leftAnchor.constraint(equalTo: socialMediaSelectionContainerView.leftAnchor).isActive = true
        socialMediaSelectionCollectionView.rightAnchor.constraint(equalTo: socialMediaSelectionContainerView.rightAnchor).isActive = true
        socialMediaSelectionCollectionView.topAnchor.constraint(equalTo: socialMediaSelectionContainerView.topAnchor).isActive = true
        
        // Selected View
        currentPositionOfSelectedContainer = view.center.y + 440
        
        socialMediaSelectedContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectedContainerView.heightAnchor.constraint(equalToConstant: 465).isActive = true
        socialMediaSelectedContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 440).isActive = true
        
        socialMediaSelectedTableView.bottomAnchor.constraint(equalTo: socialMediaSelectedContainerView.bottomAnchor).isActive = true
        socialMediaSelectedTableView.leftAnchor.constraint(equalTo: socialMediaSelectedContainerView.leftAnchor).isActive = true
        socialMediaSelectedTableView.rightAnchor.constraint(equalTo: socialMediaSelectedContainerView.rightAnchor).isActive = true
        socialMediaSelectedTableView.topAnchor.constraint(equalTo: socialMediaSelectedContainerView.topAnchor).isActive = true
    }
    
    //# MARK: - Body Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == collectionViewTag.socialMediaSelectionTableView.rawValue {
            return socialMediaChoices.count
        } else { // if collectionView.tag == collectionViewTag.profileImageSelectionTableView.rawValue
            return socialMediaProfileImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == collectionViewTag.socialMediaSelectionTableView.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
            cell.socialMedia = socialMediaChoices[indexPath.item]
            return cell
        } else { // if collectionView.tag == collectionViewTag.profileImageSelectionTableView.rawValue
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileImageSelectionCellId, for: indexPath) as! ProfileImageSelectionCell
            cell.socialMediaProfileImage = socialMediaProfileImages[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == collectionViewTag.socialMediaSelectionTableView.rawValue {
            return UIEdgeInsetsMake(0, 14, 0, 14)
        } else { // if collectionView.tag == collectionViewTag.profileImageSelectionTableView.rawValue
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == collectionViewTag.socialMediaSelectionTableView.rawValue {
            let selectedSocialMediaChoice = socialMediaChoices[indexPath.item]
            selectedSocialMediaChoice.inputName = ""
            presentSocialMediaPopup(socialMedia: selectedSocialMediaChoice)
        } else {
            if indexPath.item == socialMediaProfileImages.count-1 {
                let imagePicker: UIImagePickerController = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                present(imagePicker, animated: true)
            }
        }
    }
    
    //# MARK: - Body Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialMediaInputs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectedCellId, for: indexPath) as! SocialMediaSelectedCell
        cell.selectedSocialMedia = socialMediaInputs[indexPath.item]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSocialMediaPopup(socialMedia: socialMediaInputs[indexPath.item])
    }
    
    // This method is needed when a row is fixed to not be deleted.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        socialMediaInputs.remove(at: indexPath.item)
        tableView.reloadData()
    }
    
    func setupNavBarButton() {
        let leftButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        var rightButton: UIBarButtonItem?
        if editingUserProfile != nil {
            rightButton = UIBarButtonItem.init(title: "Update", style: .plain, target: self, action: #selector(saveClicked))
        } else {
            rightButton = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveClicked))
        }

        leftButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 17)], for: UIControlState.normal)
        rightButton?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 17)], for: UIControlState.normal)
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // For adding it to the coredata
    func saveClicked() {
        let initialPinchPoint = CGPoint(x: (profileImageSelectionCollectionView.center.x) + (profileImageSelectionCollectionView.contentOffset.x), y: (profileImageSelectionCollectionView.center.y) + (profileImageSelectionCollectionView.contentOffset.y))
        
        // Select the chosen image from the carousel.
        let selectedIndexPath = profileImageSelectionCollectionView.indexPathForItem(at: initialPinchPoint)
        let selectedSocialMediaProfileImage = socialMediaProfileImages[(selectedIndexPath?.item)!]
        
        var uniqueID: UInt64?
        if editingUserProfile != nil {
            uniqueID = editingUserProfile?.uniqueID!.uint64Value
        } else {
            uniqueID = FirebaseManager.generateUniqueID()
        }
        
        myUserProfileImageCache.setObject((selectedSocialMediaProfileImage.profileImage)!, forKey: "\(uniqueID!)" as NSString)
        
        var userProfile: UserProfile?
        if editingUserProfile != nil {
            userProfile = UserProfile.updateProfile(socialMediaInputs, userProfile: editingUserProfile!)
        } else {
            // Save the new card information into core data.
            userProfile = UserProfile.saveProfileWrapper(socialMediaInputs, withUniqueID: uniqueID!, completionHandler: { (userCard) in
                FirebaseManager.uploadCard(userCard, withUniqueID: uniqueID!)
            })
        }
        
        // Save the image to disk.
        let profileImageData = UIManager.makeCardProfileImageData(UIImagePNGRepresentation((selectedSocialMediaProfileImage.profileImage)!)!)
        DiskManager.writeImageDataToLocal(withData: profileImageData, withUniqueID: userProfile!.uniqueID as! UInt64, withUserProfileSelection: UserProfile.userProfileSelection.myUser)
        
        // When the image chosen is from the camera roll, upload the image to firebase
        // And then update the URL link to that image.
        FirebaseManager.uploadImage(selectedSocialMediaProfileImage, completionHandler: { fetchedProfileImageURL in
            UserProfile.updateSocialMediaProfileImage(fetchedProfileImageURL, withUserProfile: userProfile!)
        })
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func presentSocialMediaPopup(socialMedia: SocialMedia) {
        let socialMediaController = SocialMediaController()
        socialMediaController.socialMedia = socialMedia
        socialMediaController.newCardControllerDelegate = self
        socialMediaController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.definesPresentationContext = true
        navigationController?.present(socialMediaController, animated: false)
    }
    
    //# Mark: - Stored Info
    
    // For adding it to the Table view.
    // This is a delegate protocol. . .
    func addSocialMediaInput(socialMedia: SocialMedia) {
        // TODO: Valid name checker.
        // i.e. no blank usernames.
        if socialMedia.inputName != "" && socialMedia.isSet == false {
            let newSocialMediaInput = SocialMedia(copyFrom: socialMedia)
            newSocialMediaInput.isSet = true
            socialMediaInputs.append(newSocialMediaInput)
            ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                guard let profileImage = fetchedSocialMediaProfileImages.first?.profileImage else {
                    return
                }
                let socialMediaProfileImage = SocialMediaProfileImage(copyFrom: newSocialMediaInput, withImage: profileImage)
                self.socialMediaProfileImages.insert(socialMediaProfileImage, at: 0)
                newSocialMediaInput.socialMediaProfileImage = socialMediaProfileImage
                DispatchQueue.main.async {
                    self.profileImageSelectionCollectionView.reloadData()
                }
            })
        } else {
            ImageFetchingManager.fetchImages(withSocialMediaInputs: [socialMedia], completionHandler: { fetchedSocialMediaProfileImages in
                guard let profileImage = fetchedSocialMediaProfileImages.first?.profileImage else {
                    return
                }
                socialMedia.socialMediaProfileImage?.profileImage = profileImage
                DispatchQueue.main.async {
                    self.profileImageSelectionCollectionView.reloadData()
                }
            })
        }
        socialMediaSelectedTableView.reloadData()
    }
    
    // MARK: - UIImagePickerControllerDelegate Delegate Implementation
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false, completion: { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let circleCropController = AACircleCropViewController()
                circleCropController.image = image
                circleCropController.delegate = self
                self.present(circleCropController, animated: false)
            }
        })
    }
    
    func circleCropDidCropImage(_ image: UIImage) {
        socialMediaProfileImages[socialMediaProfileImages.count-2].profileImage = image
        profileImageSelectionCollectionView.reloadData()
        self.dismiss(animated: false)
    }
}

