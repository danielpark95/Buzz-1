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
        setupViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UIManager.makeLabel()
        label.text = "Whatthe"
        return label
    }()
    
    let settingsButton: UIButton = {
        let button = UIManager.makeButton(imageName: "settings-button")
        button.addTarget(self, action: #selector(didSelectSettings), for: .touchUpInside)
        return button
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIManager.makeImage()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        return view
    }()
    
    func didSelectSettings() {
        
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(settingsButton)
        addSubview(separatorView)
        
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 45).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true
        
        settingsButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
}
