//
//  WalkthroughCell.swift
//  familiarize
//
//  Created by Daniel Park on 8/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughCell: UICollectionViewCell {
    
    var walkthrough: Walkthrough?{
        didSet {
            guard let walkthrough = walkthrough else {
                return
            }
            print(walkthrough.imageName)
            print(walkthrough.message)
            print(walkthrough.title)
            imageView.image = UIImage(named: walkthrough.imageName)
            
            let attributedText = NSMutableAttributedString(string: walkthrough.title, attributes: [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 26)!, NSForegroundColorAttributeName: UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)])
            
            print("hello")
            
            attributedText.append(NSAttributedString(string: "\n\n\n\(walkthrough.message)", attributes: [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 19)!, NSForegroundColorAttributeName: UIColor(red:110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1.0)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, length))
            
            textView.attributedText = attributedText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let imageView: UIImageView = {
//        let iv = UIImageView()
//        //iv.contentMode = .scaleAspectFit
//        iv.image = UIImage(named: "walkthrough1")
//        //iv.contentScaleFactor = 0.6
//        //iv.clipsToBounds = true
//        return iv
        
        return UIManager.makeImage(imageName: "walkthrough1")
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample text for now"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    func setupViews() {
        backgroundColor = .white
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        //        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        //        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        //        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        textView.anchorWithConstantsToTop(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeparatorView.anchorToTop(nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
