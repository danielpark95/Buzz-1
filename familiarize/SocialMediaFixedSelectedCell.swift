//
//  SocialMediaFixedSelectedCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/10/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMediaFixedSelectedCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Do we need the AppName?
    var selectedSocialMedia: (appName: String, imageName: String, inputName: String)? {
        didSet {
            inputTextField.placeholder = selectedSocialMedia?.inputName
            if let selectedSocialMediaImageName = selectedSocialMedia?.imageName {
                socialMediaImageView.image = UIImage(named: selectedSocialMediaImageName)
                
                // Do we need this?
                //socialMediaImageView.clipsToBounds = true
            }
            setupViews()
        }
    }
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.tintColor = UIColor(white: 0.55, alpha: 1)
        textField.textAlignment = NSTextAlignment.center
        
        return textField
    }()
    
    let socialMediaImageView: UIImageView = {
        return UIManager.makeImage()
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
        addSubview(inputTextField)
        addSubview(socialMediaImageView)
        
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        inputTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 65).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: inputTextField.intrinsicContentSize.height).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        
        socialMediaImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        socialMediaImageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        socialMediaImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
}
