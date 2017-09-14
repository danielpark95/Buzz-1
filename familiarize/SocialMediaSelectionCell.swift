//
//  SocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMediaSelectionCell: UICollectionViewCell {

    var socialMedia: SocialMedia? {
        didSet {
            if let imageName = socialMedia?.imageName {
                socialMediaImage.image = UIImage(named: imageName)
            }
            setupViews()
        }
    }
    
    let socialMediaImage: UIImageView = {
        let image = UIManager.makeImage()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(socialMediaImage)
        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

class SocialMedia: NSObject, UICollectionViewDelegateFlowLayout {
    var imageName: String?
    var appName: String?
    var inputName: String?
    var placeHolder: String?
    var isSet: Bool?
    var socialMediaProfileImage: SocialMediaProfileImage?
    
    let myAttribute = [ NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 12.0)! ]
    
    init(withAppName appName: String, withImageName imageName: String, withInputName inputName: String, withAlreadySet isSet: Bool, withPlaceHolder placeHolder: String = "") {
        self.imageName = imageName
        //let upperAppName = appName.uppercased()
        self.appName = appName
        self.inputName = inputName
        //self.inputName = NSAttributedString(string: inputName, attributes: myAttribute)
        self.isSet = isSet
        self.placeHolder = placeHolder
    }
    
    init(copyFrom: SocialMedia) {
        self.imageName = copyFrom.imageName
        self.appName = copyFrom.appName
        self.inputName = copyFrom.inputName
        self.isSet = copyFrom.isSet
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }

}

