//
//  ViewController.swift
//  familiarize
//
//  Created by Alex Oh on 5/27/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

let cellId = "cellId"
class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha:1)
        
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: cellId)
        
        // This is so that the last item doesnt get hidden by the bottom navigation bar
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 40, 0)
        
        // This is so that the scrolling animation doesnt bleed into the bottom navigation bar. 
        // Instead it ends at the bottom navigation bar.
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 40, 0)
        
        setupMenuBar()
        
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "Search-50-3x")?.withRenderingMode(.alwaysTemplate)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }
    
    func handleMore() {
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuBar.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


