//
//  ViewController.swift
//  familiarize
//
//  Created by Alex Oh on 5/27/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Foundation

extension Notification.Name {
    static let reloadContacts = Notification.Name("reloadNotification")
    static let viewProfile = Notification.Name("viewProfileNotification")
}

class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    private let cellId = "cellId"
    var userProfiles: [UserProfile]?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(ContactsController.refreshTableData(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        NotificationCenter.default.addObserver(self, selector: #selector(viewProfileNotification), name: .viewProfile, object: nil)
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadContacts, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Friends"
        
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        setupCollectionView()
        setupRefreshingAndReloading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 2
    }
    
    func viewProfileNotification() {
        viewProfile()
    }
    
    func reloadTableData() {
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        collectionView?.reloadData()
    }
    
    func refreshTableData(sender: UIRefreshControl) {
        // This is our refresh animator
        //collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        sender.endRefreshing()
    }
    
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    func setupRefreshingAndReloading() {
        collectionView?.insertSubview(refreshControl, at: 0)
        
        //collectionView?.sendSubview(toBack: refreshControl)
//        //refresher.layer.zPosition = 3
//        //refresher.isUserInteractionEnabled = false
//        if #available(iOS 10.0, *)  {
//            collectionView?.refreshControl = refreshControl
//        } else {
//            
//        }
    }
    
    func viewProfile(_ idx: Int = 0) {
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        
        let viewProfileController = ViewProfileController()
        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        if let userProfile = userProfiles?[idx] {
            viewProfileController.userProfile = userProfile
        }
        
        self.definesPresentationContext = true
        self.tabBarController?.present(viewProfileController, animated: false, completion: nil)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.userProfiles?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewProfile(indexPath.item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ContactsCell
        if let userProfile = userProfiles?[indexPath.item] {
            cell.userProfile = userProfile
        }
        return cell
    }
}
