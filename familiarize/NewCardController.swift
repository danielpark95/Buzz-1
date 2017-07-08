//
//  NewCardController.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

protocol NewCardControllerDelegate {
    func presentSocialMediaPopup(socialMedia: SocialMedia) -> Void
}

class NewCardController: UICollectionViewController, UICollectionViewDelegateFlowLayout,NewCardControllerDelegate {

    
    private let socialMediaSelectionCellId = "socialMediaSelectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Card"
        collectionView?.register(SocialMediaSelectionCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: socialMediaSelectionCellId)
        collectionView?.backgroundColor = UIColor.white
        setupNavBarButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: socialMediaSelectionCellId, for: indexPath) as! SocialMediaSelectionCell
        cell.newCardControllerDelegate = self
        return cell
    }
    
    func setupNavBarButton() {
        // TODO: Add a save button on the top right.
        let backButton = UIBarButtonItem(image: UIImage(named:"back-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentSocialMediaPopup(socialMedia: SocialMedia) {
        let socialMediaController = SocialMediaController()
        socialMediaController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController?.definesPresentationContext = true
        //navigationController?.pushViewController(socialMediaController, animated: false)
        navigationController?.present(socialMediaController, animated: false)
    }
}

