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
    func addSocialMediaInput(socialMedia: SocialMedia, new: Bool) -> Void
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

    let socialMediaChoices: [SocialMedia] = [
        SocialMedia(withAppName: "", withImageName: "dan_addbutton_orange", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "phoneNumber", withImageName: "dan_phoneNumber_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "email", withImageName: "dan_email_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebookProfile_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapChatProfile_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagramProfile_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitterProfile_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedInProfile_color", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundCloudProfile_color", withInputName: "", withAlreadySet: false),
        ]
    
    var socialMediaProfileImages: [SocialMediaProfileImage] = [
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "tjmiller7")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "dan_addprofileimage_orange", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "dan_addprofileimage_orange")!)
    ]
    
    var socialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "dan_name_black", withInputName: "Required", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "dan_bio_black", withInputName: "Optional", withAlreadySet: true)
    ]
    
    lazy var socialMediaSelectionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialMediaSelectedContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialMediaSelectionCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SocialMediaSelectionCell.self, forCellWithReuseIdentifier: self.socialMediaSelectionCellId)
        //collectionView.layer.cornerRadius = 5
        collectionView.layer.masksToBounds = true
        collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        collectionView.tag = collectionViewTag.socialMediaSelectionTableView.rawValue
        return collectionView
    }()
    
    lazy var profileImageSelectionCollectionView: UICollectionView = {
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -150)
        layout.itemSize = CGSize(width: 400, height: 400)
        //layout.sideItemAlpha = 0.75
        //layout.sideItemScale = 0.75
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
    
    lazy var socialMediaSelectedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.alwaysBounceVertical = true
        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.socialMediaSelectedCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20), NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)]
        setupView()
        setupNavBarButton()
    }
    
    func setupView() {
        
        view.addSubview(socialMediaSelectionContainerView)
        view.addSubview(socialMediaSelectedContainerView)
        view.addSubview(profileImageSelectionCollectionView)
        
        profileImageSelectionCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageSelectionCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileImageSelectionCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageSelectionCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        socialMediaSelectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectionContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectionContainerView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        socialMediaSelectionContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        
        socialMediaSelectedContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectedContainerView.heightAnchor.constraint(equalToConstant: view.frame.height - 350).isActive = true
        socialMediaSelectedContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 340).isActive = true
        
        socialMediaSelectionContainerView.addSubview(socialMediaSelectionCollectionView)
        socialMediaSelectedContainerView.addSubview(socialMediaSelectedTableView)

        socialMediaSelectionCollectionView.bottomAnchor.constraint(equalTo: socialMediaSelectionContainerView.bottomAnchor).isActive = true
        socialMediaSelectionCollectionView.leftAnchor.constraint(equalTo: socialMediaSelectionContainerView.leftAnchor).isActive = true
        socialMediaSelectionCollectionView.rightAnchor.constraint(equalTo: socialMediaSelectionContainerView.rightAnchor).isActive = true
        socialMediaSelectionCollectionView.topAnchor.constraint(equalTo: socialMediaSelectionContainerView.topAnchor).isActive = true
        
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
            presentSocialMediaPopup(socialMedia: socialMediaChoices[indexPath.item])
        } else {
            if indexPath.item == socialMediaProfileImages.count-2 {
                let imagePicker: UIImagePickerController = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(imagePicker, animated: true)
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
        let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        let saveButton = UIBarButtonItem.init(title: "Save", style: .plain, target: self, action: #selector(saveClicked))
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 17)], for: UIControlState.normal)
        saveButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 17)], for: UIControlState.normal)

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
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
        
        let uniqueID = FirebaseManager.generateUniqueID()
        print("Assigning image to cache")
        print("\(uniqueID) is the uniqueID")
        myUserProfileImageCache.setObject((selectedSocialMediaProfileImage.profileImage)!, forKey: "\(uniqueID)" as NSString)
        
        // Save the new card information into core data.
        let newUserProfile = UserProfile.saveProfileWrapper(socialMediaInputs, withUniqueID: uniqueID)
        
        // Save the image to disk.
        let profileImageData = UIManager.makeCardProfileImageData(UIImagePNGRepresentation((selectedSocialMediaProfileImage.profileImage)!)!)
        DiskManager.writeImageDataToLocal(withData: profileImageData, withUniqueID: newUserProfile.uniqueID as! UInt64, withUserProfileSelection: UserProfile.userProfileSelection.myUser)
        
        // When the image chosen is from the camera roll, upload the image to firebase
        // And then update the URL link to that image.
        FirebaseManager.uploadImage(selectedSocialMediaProfileImage, completionHandler: { fetchedProfileImageURL in
            UserProfile.updateSocialMediaProfileImage(fetchedProfileImageURL, withUserProfile: newUserProfile)
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
    func addSocialMediaInput(socialMedia: SocialMedia, new: Bool) {
        // TODO: Valid name checker. 
        // i.e. no blank usernames.
        if (socialMedia.inputName != "" && socialMedia.isSet == false)  ||  new {
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

