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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    let selectProfileInstruction: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Select profile image"
        return label
    }()
    
    lazy var selectButton: UIButton = {
       let button = UIManager.makeButton()
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        let attributedText = NSAttributedString(string: "Confirm", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(attributedText, for: .normal)

        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(selectClicked), for: .touchUpInside)
        return button
    }()
    
    func selectClicked() {
        let initialPinchPoint = CGPoint(x: (self.collectionView?.center.x)! + (self.collectionView?.contentOffset.x)!, y: (self.collectionView?.center.y)! + (self.collectionView?.contentOffset.y)!)
        
        let selectedIndexPath = collectionView?.indexPathForItem(at: initialPinchPoint)
        
        // Error can occur right here for right now when there's no profile image to choose from
        UserProfile.saveProfileWrapper(socialMediaInputs!, withSocialMediaProfileImage: (socialMediaProfileImages?[(selectedIndexPath?.item)!])!)

        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

    }

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
        selectButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
    
}
