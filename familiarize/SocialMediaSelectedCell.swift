//
//  SocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/8/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
//
//

import UIKit

class SocialMediaSelectedCell: UITableViewCell, UITextFieldDelegate {
    
    var selectedSocialMedia: SocialMedia? {
        didSet {
            if let selectedSocialMediaInputName = selectedSocialMedia?.inputName {
                socialMediaInputName.text = selectedSocialMediaInputName
            }
            
            if let selectedSocialMediaImageName = selectedSocialMedia?.imageName {
                socialMediaImageView.image = UIImage(named: selectedSocialMediaImageName)
            }
            socialMediaInputName.placeholder = selectedSocialMedia?.appName
            setupViews()
        }
    }
    
    let socialMediaImageView: UIImageView = {
       return UIManager.makeImage()
    }()
    
    lazy var socialMediaInputName : UITextField = {
        let textField = UITextField()
        //change to "name" and "bio" for name and bio. username doesn't really make sense.
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.tintColor = UIColor(white: 0.55, alpha: 1)
        textField.textAlignment = NSTextAlignment.left
        textField.delegate = self
        textField.isEnabled = false
        return textField
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func setupViews() {
        addSubview(separatorView)
        addSubview(socialMediaInputName)
        addSubview(socialMediaImageView)
        
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 15).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        socialMediaInputName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
        socialMediaInputName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        
        socialMediaImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        socialMediaImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        socialMediaImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
