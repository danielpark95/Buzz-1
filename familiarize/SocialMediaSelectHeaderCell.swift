//
//  SocialMediaSelectHeaderCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/15/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMediaSelectHeader: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let sectionTitle: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
    }()
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        addSubview(sectionTitle)
        addSubview(separatorView)
        
        sectionTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sectionTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sectionTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}
