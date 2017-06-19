//
//  FamiliarizeController.swift
//  familiarize
//
//  Created by Alex Oh on 5/31/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit


class FamiliarizeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Familiarize"
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupView()
        setupCollectionView()

    }
    
    lazy var cameraButton: UIButton = {
        let image = UIImage(named: "camera-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectCamera), for: .touchUpInside)
        return button
    }()
    
    func didSelectCamera() {
        let cameraController = QRScannerController()
        self.present(cameraController, animated: false)
    }
    
    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        view.addSubview(cameraButton)
        
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha:1)
        collectionView?.register(FamiliarizeCell.self, forCellWithReuseIdentifier: self.cellId)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
        collectionView?.isPagingEnabled = true
        
    }
    
    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = 3 // Change the number of pages to something else after you get like the coredata working
        pc.currentPageIndicatorTintColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha:1)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // Change the number of pages to something else after you get like the coredata working
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.he)
        //return CGSize(width: view.frame.width, height: view.frame.height)
        return self.collectionView!.frame.size;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

