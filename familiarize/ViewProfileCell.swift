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
        // Must enable scrollDirection as horizontal even though scrolling is disabled.
        // This is so the layout of the items are horizontally displayed.
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ViewProfileSocialMediaCell.self, forCellWithReuseIdentifier: self.viewProfileSocialMediaCellId)
        collectionView.isScrollEnabled = false
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
        userSocialMediaCollectionView.widthAnchor.constraint(equalToConstant: 326).isActive = true
        userSocialMediaCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
    
    // MARK: EVERYTHING IS NOT COMPLETE.
    // This is used to center everything in the middle.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if (socialMediaInputs?.count == 1 ) {
            return UIEdgeInsetsMake(0, 113, 0, 0)
        } else if (socialMediaInputs?.count == 2 ) {
            return UIEdgeInsetsMake(0, 63, 0, 0)
        } else if (socialMediaInputs?.count == 6 ) {
            return UIEdgeInsetsMake(15, 43, 15, 0)
        } else {
            return UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
    
    // This is used to create spacings within each of the social media buttons.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let count = socialMediaInputs?.count else {
            return CGSize()
        }
        
        if count == 1 {
            return CGSize(width: 100.0, height: 75)
        } else if count == 2 {
            return CGSize(width: 100.0, height: 75)
        } else if count == 6 {
            return CGSize(width: 80.0, height: 50.0)
        }
        return CGSize(width: 120.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
