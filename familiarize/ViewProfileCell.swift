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
        //layout.itemSize = CGSize(width: 300, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ViewProfileSocialMediaCell.self, forCellWithReuseIdentifier: self.viewProfileSocialMediaCellId)
        collectionView.backgroundColor = .white
        //collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    
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
        userSocialMediaCollectionView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        userSocialMediaCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    //# MARK: - Body Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(socialMediaInputs?.count)
        return socialMediaInputs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(" i ahve been called!")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewProfileSocialMediaCellId, for: indexPath) as! ViewProfileSocialMediaCell
        cell.socialMedia = socialMediaInputs?[indexPath.item]
        return cell
    }
}
