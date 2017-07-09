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

class NewCardController: UICollectionViewController, UICollectionViewDelegateFlowLayout,NewCardControllerDelegate {

    var socialMediaInputs: [(key: String, value: String)] = []
    
    private let socialMediaSelectionCellId = "socialMediaSelectionCell"
    private let socialMediaSelectedCell = "socialMediaSelectedCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Card"
        setupCollectionView()
        setupNavBarButton()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialMediaInputs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: socialMediaSelectedCell, for: indexPath) as! SocialMediaSelectedCell
        cell.selectedSocialMedia = socialMediaInputs[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
        cell.newCardControllerDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(SocialMediaSelectedCell.self, forCellWithReuseIdentifier: socialMediaSelectedCell)
        collectionView?.register(SocialMediaSelectionCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: socialMediaSelectionCellId)
        collectionView?.backgroundColor = UIColor.white
    }
    
    func setupNavBarButton() {
        let cancelButton = UIBarButtonItem.init(title: "cancel", style: .plain, target: self, action: #selector(cancelClicked))
        let saveButton = UIBarButtonItem.init(title: "save", style: .plain, target: self, action: #selector(saveClicked))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveClicked() {
        print("tacos")
    }
    
    
    func presentSocialMediaPopup(socialMedia: SocialMedia) {
        let socialMediaController = SocialMediaController()
        socialMediaController.socialMedia = socialMedia
        socialMediaController.newCardControllerDelegate = self
        socialMediaController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.definesPresentationContext = true
        navigationController?.present(socialMediaController, animated: false)
    }
    
    func addSocialMediaInput(socialMedia: SocialMedia) {
        if let inputName = socialMedia.inputName {
            socialMediaInputs.append((socialMedia.name!, inputName))
            collectionView?.reloadData()
        }
    }
}

