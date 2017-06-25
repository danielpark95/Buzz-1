//
//  UserController.swift
//  familiarize
//
//  Created by Alex Oh on 6/17/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    
    var myUserProfiles: [MyUserProfile]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Info"
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupView()
        setupCollectionView()
    }
    


    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        

    }
    
    func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
        collectionView?.register(FamiliarizeCell.self, forCellWithReuseIdentifier: self.cellId)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
        
    }
    
    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        //pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = 3 // Change the number of pages to something else after you get like the coredata working
        pc.currentPageIndicatorTintColor = UIColor.white
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Modify this after you saved a user.
//        if let count = self.myUserProfiles?.count {
//            return count
//        }
//        return 0
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView!.frame.size;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}

