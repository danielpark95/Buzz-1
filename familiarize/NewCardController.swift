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
    func deleteSocialMediaInput(socialMedia: SocialMedia) -> Void
}



class NewCardController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NewCardControllerDelegate {

    var optionalSocialMediaInputs: [SocialMedia] = []

    var requiredSocialMediaInputs: [SocialMedia] = [
        SocialMedia(withAppName: "name", withImageName: "dan_facebook_black", withInputName: "Required", withAlreadySet: true),
        SocialMedia(withAppName: "bio", withImageName: "dan_facebook_black", withInputName: "Optional", withAlreadySet: true)
    ]
    
    private let socialMediaSelectionCellId = "socialMediaSelectionCellId"
    private let socialMediaSelectedCellId = "socialMediaSelectedCellId"
    private let socialMediaHeaderCellId = "socialMediaHeaderCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Card"
        navigationController?.navigationBar.tintColor = UIColor.black
        setupCollectionView()
        setupNavBarButton()
    }
    
    //# MARK: - Header Collection View
    
    // This is our header. Independent of the social media inputs. 
    // This calls the SocialMediaSelectionCell class.
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: socialMediaHeaderCellId, for: indexPath) as! SocialMediaSelectHeader
        if indexPath.section == 0 {
            cell.sectionTitle.attributedText = NSMutableAttributedString(string: "Add", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 14)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
        } else {
            cell.sectionTitle.attributedText = NSMutableAttributedString(string: "My Info", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 14)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //# MARK: - Body Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return optionalSocialMediaInputs.count + requiredSocialMediaInputs.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
            cell.newCardControllerDelegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: socialMediaSelectedCellId, for: indexPath) as! SocialMediaSelectedCell

            cell.deleteButton.layer.setValue(indexPath.item, forKey: "index")
            cell.deleteButton.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
            cell.deleteButton.isHidden = false
            
            if indexPath.item < 2 {
                cell.deleteButton.isHidden = true
            }
            
            if indexPath.item < requiredSocialMediaInputs.count {
                cell.selectedSocialMedia = requiredSocialMediaInputs[indexPath.item]
            } else { //if indexPath.item >= optionalSocialMediaInputs.count
                cell.selectedSocialMedia = optionalSocialMediaInputs[indexPath.item - requiredSocialMediaInputs.count]
            }

            return cell
        }
    }

    func deleteClicked(_ sender: UIButton) {
        let indexPathItem : Int = (sender.layer.value(forKey: "index")) as! Int
        deleteSocialMediaInput(socialMedia: optionalSocialMediaInputs[indexPathItem-2])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 100)
        } else {
            return CGSize(width: view.frame.width, height: 60)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.item < requiredSocialMediaInputs.count {
                self.presentSocialMediaPopup(socialMedia: requiredSocialMediaInputs[indexPath.item])
            } else {
                self.presentSocialMediaPopup(socialMedia: optionalSocialMediaInputs[indexPath.item - requiredSocialMediaInputs.count])
            }
        }
    }
    
    //# MARK: - Setup Views
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(SocialMediaSelectedCell.self, forCellWithReuseIdentifier: socialMediaSelectedCellId)
        collectionView?.register(SocialMediaSelectionCell.self, forCellWithReuseIdentifier: socialMediaSelectionCellId)
        collectionView?.register(SocialMediaSelectHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: socialMediaHeaderCellId)

        collectionView?.backgroundColor = UIColor.white
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
    
    // For adding it to the collection view.
    func addSocialMediaInput(socialMedia: SocialMedia) {
        // TODO: Valid name checker. 
        // i.e. no blank usernames.
        if socialMedia.inputName != "" && socialMedia.isSet == false {
            let newSocialMediaInput = SocialMedia(copyFrom: socialMedia)
            newSocialMediaInput.isSet = true
            optionalSocialMediaInputs.append(newSocialMediaInput)
        }
        collectionView?.reloadData()
    }
    
    // For adding it to the coredata
    func nextClicked() {
        
        requiredSocialMediaInputs.append(contentsOf: optionalSocialMediaInputs)
        requiredSocialMediaInputs.sort(by: { $0.appName! < $1.appName! })
        let socialMediaInputs: [SocialMedia] = requiredSocialMediaInputs
        
        //# MARK: - Presenting ProfileImageSelectionController
        
        let loadingProfileImageSelectionController = LoadingProfileImageSelectionController()
        loadingProfileImageSelectionController.socialMediaInputs = socialMediaInputs
        navigationController?.pushViewController(loadingProfileImageSelectionController, animated: true)
    }
    
    //# Mark: - Delete Info
    func deleteSocialMediaInput(socialMedia: SocialMedia) {
        for index in 0...optionalSocialMediaInputs.count {
            if (optionalSocialMediaInputs[index] == socialMedia) {
                optionalSocialMediaInputs.remove(at: index)
                collectionView?.reloadData()
                return
            }
        }
    }
    
    
}

