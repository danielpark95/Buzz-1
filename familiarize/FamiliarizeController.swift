//
//  FamiliarizeController.swift
//  familiarize
//
//  Created by Alex Oh on 5/31/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

let famCellId = "cellId"
class FamiliarizeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Familiarize"
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha:1)
        
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: famCellId)
        
        setupColectionView()

    }
    func setupColectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: famCellId, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

