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
    static let reload = Notification.Name("reloadNotification")
    static let viewProfile = Notification.Name("viewProfileNotification")
    static let changeBrightness = Notification.Name("UIScreenBrightnessDidChangeNotification")
}

class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    private let cellId = "cellId"
    var userProfiles: [UserProfile]?
    var refresher:UIRefreshControl = UIRefreshControl()
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 2
        //UIScreen.main.brightness = delegate.userBrightnessLevel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Friends"
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search... "
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        setupRefreshingAndReloading()
        setupCollectionView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        collectionView?.reloadData()
    }
    
    func viewProfileNotification() {
        self.viewProfile()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        NotificationCenter.default.addObserver(self, selector: #selector(viewProfileNotification), name: .viewProfile, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewProfile(_ idx: Int = 0) {
        
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        
        let viewProfileController = ViewProfileController()
        
        if let userProfile = userProfiles?[idx] {
            
            viewProfileController.userProfile = userProfile
        }
        
        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.definesPresentationContext = true
        self.present(viewProfileController, animated: false)
    }
    
    
    func setupRefreshingAndReloading() {
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        //This is a different signal from the one written in notification center. This signal is fired whenever a user drags down the collection view in contacts.
        if #available(iOS 10.0, *)  {
            self.refresher.addTarget(self, action: #selector(ContactsController.refreshTableData), for: UIControlEvents.valueChanged)
            collectionView?.refreshControl = self.refresher
        } else {
            collectionView?.addSubview(refresher)
        }
    }
    
    func setupCollectionView() {
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    func reloadTableData() {
        userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        collectionView?.reloadData()
    }
    
    func refreshTableData() {
        // This is our refresh animator
        //collectionView!.refreshControl?.beginRefreshing()
        
        collectionView?.refreshControl?.endRefreshing()
        collectionView?.refreshControl?.isHidden = true
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.userProfiles?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ContactsCell
        
        if let userProfile = userProfiles?[indexPath.item] {
            cell.userProfile = userProfile
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewProfile(indexPath.item)
    }


}
