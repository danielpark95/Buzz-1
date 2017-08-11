//
//  WalkthroughStartCell.swift
//  familiarize
//
//  Created by Daniel Park on 8/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughStartCell: UICollectionViewCell {
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    weak var delegate : WalkthroughControllerDelegate?
    
    func handleStart() {
        delegate?.finishWalkthrough()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(startButton)
        
        _ = startButton.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -200, leftConstant:  0, bottomConstant:  0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        startButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
