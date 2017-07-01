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
            iconImageView.tintColor = isHighlighted ? UIColor.darkGray : UIColor.black
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            iconImageView.image = UIImage(named: (setting?.imageName)!)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = UIColor.black
            
            addSubview(iconImageView)
            if (nameLabel.text == "") {
                iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
                self.layoutIfNeeded()
            } else {
                iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
                iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            }
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
    
//    // This creates the line in between each of the cells.
//    let separatorView: UIView = {
//        let view = UIManager.makeImage()
//        view.backgroundColor = UIColor(white: 0.95, alpha:1)
//        return view
//    }()
    
    func didSelectSettings() {
        
    }
    
    func setupViews() {
        
        
        addSubview(nameLabel)
//        addSubview(separatorView)
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        

        
//        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
}
