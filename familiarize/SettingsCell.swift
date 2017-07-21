//
//  SettingsCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            nameLabel.textColor = isHighlighted ? UIColor.darkGray : UIColor.black
//            iconImageView.tintColor = isHighlighted ? UIColor.darkGray : UIColor.clear
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.attributedText = NSMutableAttributedString(string: (setting?.name.rawValue)!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)])
            iconImageView.image = UIImage(named: (setting?.imageName)!)?.withRenderingMode(.alwaysOriginal)
            setupViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        return UIManager.makeLabel()
    }()
    
    let iconImageView: UIImageView = {
        return UIManager.makeImage()
    }()
    
    func setupViews() {
        
        addSubview(iconImageView)
        if (nameLabel.text == "") {
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            
            iconImageView.tintColor = UIColor.black
            iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            addSubview(nameLabel)
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        }
        
    
    }
    
    
}
