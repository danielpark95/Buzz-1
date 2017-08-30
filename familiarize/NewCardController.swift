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

protocol NewCardControllerDelegate {
    func presentSocialMediaPopup(socialMedia: SocialMedia) -> Void
    func addSocialMediaInput(socialMedia: SocialMedia) -> Void
}

class NewCardController: UIViewController, NewCardControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let profileImageSelectionCellId = "profileImageSelectionCellId"
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    
    private enum collectionViewTag: Int {
        case profileImageSelectionTableView
        case socialMediaSelectionTableView
    }

    let socialMediaChoices: [SocialMedia] = [
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebook_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapchat_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagram_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitter_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedin_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundcloud_black", withInputName: "", withAlreadySet: false),
        ]
    
    var socialMediaProfileImages: [SocialMediaProfileImage] = [
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "tjmiller7")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "tjmiller7")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "tjmiller7")!),
        SocialMediaProfileImage(copyFrom: SocialMedia(withAppName: "default", withImageName: "tjmiller7", withInputName: "default", withAlreadySet: false), withImage: UIImage(named: "tjmiller7")!)
    ]
    
    lazy var socialMediaSelectionContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialMediaSelectedContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
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
        collectionView.layer.cornerRadius = 32
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
        layout.sideItemAlpha = 0.75
        layout.sideItemScale = 0.75
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

    var socialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "dan_name_black", withInputName: "Required", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "dan_bio_black", withInputName: "Optional", withAlreadySet: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor.black
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
        profileImageSelectionCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        
        socialMediaSelectionContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectionContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectionContainerView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        socialMediaSelectionContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
        
        socialMediaSelectedContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedContainerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        socialMediaSelectedContainerView.heightAnchor.constraint(equalToConstant: view.frame.height - 360).isActive = true
        socialMediaSelectedContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 360).isActive = true
        
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
        let cancelButton = UIBarButtonItem.init(title: "cancel", style: .plain, target: self, action: #selector(cancelClicked))
        let nextButton = UIBarButtonItem.init(title: "next", style: .plain, target: self, action: #selector(nextClicked))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
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
    func addSocialMediaInput(socialMedia: SocialMedia) {
        // TODO: Valid name checker. 
        // i.e. no blank usernames.
        if socialMedia.inputName != "" && socialMedia.isSet == false {
            let newSocialMediaInput = SocialMedia(copyFrom: socialMedia)
            newSocialMediaInput.isSet = true
            socialMediaInputs.append(newSocialMediaInput)
        }
        socialMediaSelectedTableView.reloadData()
    }
    
    // For adding it to the coredata
    func nextClicked() {
        //socialMediaInputs.sort(by: { $0.appName! < $1.appName! })
        //# MARK: - Presenting ProfileImageSelectionController
        let loadingProfileImageSelectionController = LoadingProfileImageSelectionController()
        loadingProfileImageSelectionController.socialMediaInputs = socialMediaInputs
        navigationController?.pushViewController(loadingProfileImageSelectionController, animated: true)
    }
}

