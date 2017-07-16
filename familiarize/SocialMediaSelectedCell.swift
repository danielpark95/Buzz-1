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

class SocialMediaSelectedCell: UICollectionViewCell {
    
    var selectedSocialMedia: SocialMedia? {
        didSet {
            if let selectedSocialMediaInputName = selectedSocialMedia?.inputName {
                socialMediaInputName.text = selectedSocialMediaInputName
            }
            
            if let selectedSocialMediaImageName = selectedSocialMedia?.imageName {
                socialMediaImageView.image = UIImage(named: selectedSocialMediaImageName)
                
                // Do we need this?
                //socialMediaImageView.clipsToBounds = true
            }
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let socialMediaImageView: UIImageView = {
       return UIManager.makeImage()
    }()
    
    let socialMediaInputName: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let deleteButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_help")
        return button
    }()
    

    func setupViews() {
        addSubview(separatorView)
        addSubview(socialMediaInputName)
        addSubview(socialMediaImageView)
        addSubview(deleteButton)
        
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        socialMediaInputName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaInputName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        socialMediaInputName.heightAnchor.constraint(equalToConstant: socialMediaInputName.intrinsicContentSize.height).isActive = true
        socialMediaInputName.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        socialMediaImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        socialMediaImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        socialMediaImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }

}
