//
//  ViewProfileSocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 8/30/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
import UIKit

class ViewProfileSocialMediaCell: UICollectionViewCell {
    
    fileprivate let viewProfileSocialMediaCellId = "viewProfileSocialMediaCellId"
    var socialMedia: SocialMedia? {
        didSet {
            if let imageName = socialMedia?.imageName {
                let image = UIImage(named: imageName)
                socialMediaButton.setImage(image, for: .normal)
                setupViews()
            }
        }
    }
    
    lazy var socialMediaButton: UIButton = {
        let button = UIManager.makeButton()
        return button
    }()
    
    func setupViews() {
        addSubview(socialMediaButton)
        socialMediaButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        socialMediaButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        socialMediaButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
