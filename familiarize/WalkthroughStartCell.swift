//
//  WalkthroughStartCell.swift
//  familiarize
//
//  Created by Daniel Park on 8/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit
import Cheers

class WalkthroughStartCell: UICollectionViewCell {
    let imageView: UIImageView = {
        //        let iv = UIImageView()
        //        //iv.contentMode = .scaleAspectFit
        //        iv.image = UIImage(named: "walkthrough1")
        //        //iv.contentScaleFactor = 0.6
        //        //iv.clipsToBounds = true
        //        return iv
        
        return UIManager.makeImage(imageName: "pg4_new")
    }()
    
    lazy var startButton: UIButton = {
        let button = UIManager.makeButton(imageName: "dan_start_button_yellow")
        //button.backgroundColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        //button.setTitle("Start", for: .normal)
        //button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    weak var delegate : walkThroughControllerDelegate?
    
    func handleStart() {
        delegate?.finishWalkthrough()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(startButton)
        addSubview(imageView)
        
        _ = startButton.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: 185, leftConstant:  0, bottomConstant:  0, rightConstant: 0, widthConstant: 300, heightConstant: 0)
        startButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
