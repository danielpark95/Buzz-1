//
//  SocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMediaSelectionCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This creates the line in between each of the cells.
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha:1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private let cellId = "cellId"
    let socialMediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(socialMediaCollectionView)
        addSubview(separatorView)
        
        socialMediaCollectionView.dataSource = self
        socialMediaCollectionView.delegate = self
        socialMediaCollectionView.register(SocialMediaCell.self, forCellWithReuseIdentifier: cellId)
        
        socialMediaCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        socialMediaCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        socialMediaCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        socialMediaCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let socialMediaController = SocialMediaController()
        

        socialMediaController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        //self.definesPresentationContext = true
        //UINavigationController.present(socialMediaController, animated: false)
    }

    
    
}

class SocialMediaCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let socialMediaImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "dan_facebook_red")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let socialMediaLabel: UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        label.font = UIFont.systemFont(ofSize: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(socialMediaImage)
        addSubview(socialMediaLabel)
        
        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        socialMediaLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        socialMediaLabel.heightAnchor.constraint(equalToConstant: socialMediaLabel.intrinsicContentSize.height).isActive = true
        socialMediaLabel.widthAnchor.constraint(equalToConstant: socialMediaLabel.intrinsicContentSize.width).isActive = true
        
    }
}
