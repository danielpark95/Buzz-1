//
//  ViewProfileCell.swift
//  familiarize
//
//  Created by Alex Oh on 8/30/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class ViewProfileCell: UICollectionViewCell,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    fileprivate let viewProfileSocialMediaCellId = "viewProfileSocialMediaCellId"
    var socialMediaInputs: [SocialMedia]?
    
    lazy var userSocialMediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ViewProfileSocialMediaCell.self, forCellWithReuseIdentifier: self.viewProfileSocialMediaCellId)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(userSocialMediaCollectionView)
        userSocialMediaCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userSocialMediaCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userSocialMediaCollectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userSocialMediaCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    //# MARK: - Body Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialMediaInputs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewProfileSocialMediaCellId, for: indexPath) as! ViewProfileSocialMediaCell
        cell.socialMedia = socialMediaInputs?[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if (socialMediaInputs?.count == 1 ) {
            return UIEdgeInsetsMake(0, 127, 0, 127)
        } else if (socialMediaInputs?.count == 2 ) {
            return UIEdgeInsetsMake(0, 42, 0, 42)
        } else if (socialMediaInputs?.count == 3 ) {
            return UIEdgeInsetsMake(0, -1.5, 0, -1.5)
        } else {
            return UIEdgeInsetsMake(0, 10, 0, 10)
        }
        
    }
}
