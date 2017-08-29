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

protocol NewCardControllerDelegate {
    func presentSocialMediaPopup(socialMedia: SocialMedia) -> Void
    func addSocialMediaInput(socialMedia: SocialMedia) -> Void
}

class NewCardController: UIViewController, NewCardControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let profileImageSelectionCellId = "profileImageSelectionCellId"
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    
    private enum tableViewTag: Int {
        case profileImageSelectionTableView
        case socialMediaSelectionTableView
        case socialMediaSelectedTableView
    }

    
    let socialMediaChoices: [SocialMedia] = [
        SocialMedia(withAppName: "faceBookProfile", withImageName: "dan_facebook_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "snapChatProfile", withImageName: "dan_snapchat_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "instagramProfile", withImageName: "dan_instagram_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "twitterProfile", withImageName: "dan_twitter_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "linkedInProfile", withImageName: "dan_linkedin_black", withInputName: "", withAlreadySet: false),
        SocialMedia(withAppName: "soundCloudProfile", withImageName: "dan_soundcloud_black", withInputName: "", withAlreadySet: false),
        ]
    
    lazy var socialMediaCollectionView: UICollectionView = {
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
        collectionView.layer.cornerRadius = 27
        collectionView.layer.masksToBounds = true
        collectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        return collectionView
    }()
    
//    lazy var profileImageSelectionTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
//        tableView.alwaysBounceVertical = true
//        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.profileImageSelectionCellId)
//        tableView.backgroundColor = .white
//        tableView.separatorStyle = .none
//        tableView.delegate = self
//        tableView.dataSource = self
//        return tableView
//    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var socialMediaSelectedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tableView.alwaysBounceVertical = false
        tableView.register(SocialMediaSelectedCell.self, forCellReuseIdentifier: self.socialMediaSelectedCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tag = tableViewTag.socialMediaSelectedTableView.rawValue
        
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
        view.addSubview(containerView)
        view.addSubview(socialMediaCollectionView)
        view.addSubview(socialMediaSelectedTableView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
        
        containerView.addSubview(socialMediaCollectionView)
        
        socialMediaCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        socialMediaCollectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        socialMediaCollectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        socialMediaCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        socialMediaSelectedTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        socialMediaSelectedTableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        socialMediaSelectedTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        socialMediaSelectedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
    }
    
    //# MARK: - Body Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialMediaChoices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
        cell.socialMedia = socialMediaChoices[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentSocialMediaPopup(socialMedia: socialMediaChoices[indexPath.item])
    }

    //# MARK: - Body Table View
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return socialMediaInputs.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: socialMediaSelectedCellId, for: indexPath) as! SocialMediaSelectedCell
        cell.selectedSocialMedia = socialMediaInputs[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSocialMediaPopup(socialMedia: socialMediaInputs[indexPath.item])
    }
    
    // This method is needed when a row is fixed to not be deleted.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == tableViewTag.socialMediaSelectedTableView.rawValue {
            return true
        }
        return false
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

