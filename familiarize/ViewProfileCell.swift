//
//  ViewProfileCell.swift
//  familiarize
//
//  Created by Alex Oh on 8/30/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ViewProfileCell: UICollectionViewCell {

    var socialMedia: SocialMedia? {
        didSet {
            print("what a burger")
            if let imageName = socialMedia?.imageName {
                let image = UIImage(named: imageName)
                socialMediaButton.setImage(image, for: .normal)
                print("huh")
                setupViews()
            }
        }
    }
    
    lazy var socialMediaButton: UIButton = {
        let button = UIManager.makeButton()
        return button
    }()
    
    func setupViews() {
        self.backgroundColor = UIColor.clear
        addSubview(socialMediaButton)
        socialMediaButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        socialMediaButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        socialMediaButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
