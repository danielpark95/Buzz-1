//
//  CellBaseClass.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//
import UIKit

// Refactoring redundant code so that any new cell can use this shabang.
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
