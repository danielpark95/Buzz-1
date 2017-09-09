//
//  ProfileImageSelectionCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/13/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ProfileImageSelectionCell: UICollectionViewCell {
    
    var socialMediaProfileImage: SocialMediaProfileImage? {
        didSet {
            if socialMediaProfileImage?.profileImage != nil {
                self.profileImage.image = socialMediaProfileImage?.profileImage
            }
            setupViews()
        }
    }
    
    let profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 83)
    }()
    
    
    lazy var profileImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.shadowColor = UIColor.darkGray.cgColor
        //view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //view.layer.shadowOpacity = 1.0
        //view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func setupViews() {
        self.backgroundColor = UIColor.clear
        addSubview(profileImageContainerView)
        
        profileImageContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageContainerView.widthAnchor.constraint(equalToConstant: 166).isActive = true
        profileImageContainerView.heightAnchor.constraint(equalToConstant: 166).isActive = true

        profileImageContainerView.addSubview(profileImage)
        profileImage.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: profileImageContainerView.leftAnchor).isActive = true
        profileImage.rightAnchor.constraint(equalTo: profileImageContainerView.rightAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor).isActive = true
    }
}
