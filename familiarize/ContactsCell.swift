//
//  contactsCell.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ContactsCell: BaseCell {

    var userProfile: UserProfile? {
        didSet {

            let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string:"\nAdded " + (userProfile?.date?.getElapsedTime())!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
            
            nameLabelAndTime.attributedText = attributedText
        }
    }
    // A quick and easy way to create a uiview. UILabel is a subclass of uiview.
    let nameLabelAndTime: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blank_man")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    
    override func setupViews() {
        backgroundColor = UIColor.white
        addSubview(nameLabelAndTime)
        addSubview(profileImageView)
        addSubview(separatorView)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        nameLabelAndTime.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabelAndTime.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabelAndTime.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameLabelAndTime.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        
    }
    
    
}
