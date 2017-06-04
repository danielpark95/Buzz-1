//
//  MenuBar.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

// This code has been deprecated and is no longer in service.

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha:1)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["Search-50", "Fam-100-Border-Decrease", "User-50"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // When we first began registering the cells, we put the first parameter as "UICollectionViewCell.self". This is to just hold a static cell that was created by apple. but as things go more complex, we now added our own cell that we want to show in the row's section.
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        let selectedIndexPath = NSIndexPath(item: 1, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        cell.tintColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override var isHighlighted : Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0) : UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0) : UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
        }
    }

    
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    
}
