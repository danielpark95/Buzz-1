//
//  ProfileImageSelectionController.swift
//  familiarize
//
//  Created by Alex Oh on 7/13/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import SwiftyJSON

class ProfileImageSelectionController: UICollectionViewController {
    
    private let cellId = "cellId"
    
    var socialMediaProfileImages: [SocialMediaProfileImage]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    let selectProfileInstruction: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Select profile image"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
    }
    
    func setupCollectionView() {
        self.collectionView?.backgroundColor = UIColor.white
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.register(ProfileImageSelectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func setupViews() {
        view.addSubview(selectProfileInstruction)
        selectProfileInstruction.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectProfileInstruction.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        selectProfileInstruction.widthAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.width).isActive = true
        selectProfileInstruction.heightAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.height).isActive = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = socialMediaProfileImages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ProfileImageSelectionCell
        
        if let socialMediaProfileImage = socialMediaProfileImages?[indexPath.item] {
            cell.socialMediaProfileImage = socialMediaProfileImage
        }
        
        return cell
    }
    
    func saveSocialMediaInputs(_ socialMediaInputs: [SocialMedia]) {
        var concantenatedSocialMediaInputs: [(socialMediaName: String, inputName: String)] = []
        
        var currentSocialMediaName: String = ""
        for eachSocialInput in socialMediaInputs {
            if eachSocialInput.appName == currentSocialMediaName {
                concantenatedSocialMediaInputs[(concantenatedSocialMediaInputs.count)-1].inputName = concantenatedSocialMediaInputs[(concantenatedSocialMediaInputs.count)-1].inputName + ",\(eachSocialInput.inputName!)"
            } else {
                currentSocialMediaName = eachSocialInput.appName!
                concantenatedSocialMediaInputs.append((eachSocialInput.appName!, eachSocialInput.inputName!))
                print(concantenatedSocialMediaInputs.count)
            }
        }
        
        var toSaveCard: JSON = [:]
        for eachConcantenatedSocialMediaInput in concantenatedSocialMediaInputs {
            let currentSocialMediaName = UIManager.makeShortHandForQR(eachConcantenatedSocialMediaInput.socialMediaName)
            toSaveCard[currentSocialMediaName!].string = eachConcantenatedSocialMediaInput.inputName
        }
        
        //# Mark: - Remember to uncomment this out...
        UserProfile.clearData(forProfile: .myUser)
        
        let userProfile = UserProfile.saveProfile(toSaveCard, forProfile: .myUser)
        
    }
    
    
 
    
}
