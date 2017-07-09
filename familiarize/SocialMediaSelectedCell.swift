//
//  SocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/8/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
//
//import UIKit
//
import UIKit

class SocialMediaSelectedCell: UICollectionViewCell {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedSocialMedia: (key: String, value: String)? {
        didSet {
            if let selectedSocialMediaInputName = selectedSocialMedia?.value {
                socialMediaInputName.text = selectedSocialMediaInputName
            }
            setupViews()
        }
    }
    
    let socialMediaInputName: UILabel = {
        return UIManager.makeLabel(numberOfLines: 2)
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
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        socialMediaInputName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaInputName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        socialMediaInputName.heightAnchor.constraint(equalToConstant: socialMediaInputName.intrinsicContentSize.height).isActive = true
        socialMediaInputName.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }

}
