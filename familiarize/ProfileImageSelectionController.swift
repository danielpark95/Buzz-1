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
    
    var socialMediaProfileImages: [SocialMediaProfileImage]?
    var socialMediaInputs: [SocialMedia]?
    
    let selectProfileInstruction: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Select profile image"
        return label
    }()
    
    lazy var selectButton: UIButton = {
       let button = UIManager.makeButton()
        //button.frame = CGRect(x: view.frame.width, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: 10, right: 10)
        let attributedText = NSAttributedString(string: "Select", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.white])
        
        button.setAttributedTitle(attributedText, for: .normal)
        return button
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
        view.addSubview(selectButton)
        
        selectProfileInstruction.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectProfileInstruction.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        selectProfileInstruction.widthAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.width).isActive = true
        selectProfileInstruction.heightAnchor.constraint(equalToConstant: selectProfileInstruction.intrinsicContentSize.height).isActive = true
        
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
