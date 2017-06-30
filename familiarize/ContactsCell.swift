//
//  contactsCell.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ContactsCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userProfile: UserProfile? {
        didSet {
            // The name
            let attributedText = NSMutableAttributedString(string: (userProfile?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)])
            
            // The time
            attributedText.append(NSAttributedString(string:"\nAdded " + (userProfile?.date?.getElapsedTime())!, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1.0)]))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
            
            nameLabelAndTime.attributedText = attributedText
            
            if userProfile?.profileImage != nil {
                self.profileImage.image = UIImage(data: (userProfile?.profileImage!)!)
                self.profileImage.clipsToBounds = true
            }
            
            // Views is set after knowing how long the texts are.
            setupViews()
        }
    }
    
    // A quick and easy way to create a uiview. UILabel is a subclass of uiview.
    let nameLabelAndTime: UILabel = {
        return UIManager.makeLabel(numberOfLines: 2)
    }()
    
    let profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 22)
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    func setupViews() {
        addSubview(nameLabelAndTime)
        addSubview(separatorView)
        addSubview(profileImage)
        
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // TODO: Find a better way to dynamically create the height and width anchor.
        nameLabelAndTime.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameLabelAndTime.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        nameLabelAndTime.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nameLabelAndTime.widthAnchor.constraint(equalToConstant:400).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
