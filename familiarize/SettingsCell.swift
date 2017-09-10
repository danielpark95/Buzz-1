//
//  SettingsCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel()
    }()
    
    let iconImageView: UIImageView = {
        return UIManager.makeImage()
    }()
    
    override var isHighlighted: Bool {
        didSet {
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.white
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.white
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.attributedText = NSMutableAttributedString(string: (setting?.name.rawValue)!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
            iconImageView.image = UIImage(named: (setting?.imageName)!)?.withRenderingMode(.alwaysOriginal)
            setupViews()
        }
    }
    
    func setupViews() {
        

        if (nameLabel.text != "") {

            addSubview(iconImageView)
            addSubview(nameLabel)
            
            iconImageView.tintColor = UIColor.white
            iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            nameLabel.textColor = UIColor.white
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        }
        
    
    }
    
    
}
