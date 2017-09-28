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
        return UIManager.makeProfileImage(valueOfCornerRadius: 100)
    }()
    
    func setupViews() {
        self.backgroundColor = UIColor.clear
        addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
}
