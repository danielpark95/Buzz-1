//
//  ViewController.swift
//  familiarize
//
//  Created by Alex Oh on 5/27/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    var userProfiles: [UserProfile]?
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        
        //self.clearData()
        super.viewDidLoad()

        navigationItem.title = "Contacts"
        setupRefreshingAndReloading()
        setupCollectionView()
        setupNavBarButtons()
        
        self.loadData()
    }
    
    func setupRefreshingAndReloading() {
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        //This is a different signal from the one written in notification center. This signal is fired whenever a user drags down the collection view in contacts.
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(refreshTableData), for: UIControlEvents.valueChanged)
        collectionView?.refreshControl = refresher
        
    }
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha:1)
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    // This possibly can be extended more to create a search function for looking up contact history.
    // Look up "how to create youtube" by lets build that app
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "Search-50-3x")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }
    
    func handleMore() { // This piece of man is still here.
        
    }
    
    func reloadTableData() {
        self.loadData()
        collectionView?.reloadData()
    }
    
    func refreshTableData() {
        collectionView!.refreshControl?.beginRefreshing()
        collectionView?.reloadData()
        collectionView?.refreshControl?.endRefreshing()
    }
    
    func loadData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            self.userProfiles = try(managedObjectContext.fetch(fetchRequest)) as? [UserProfile]

        } catch let err {
            print(err)
        }
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

    // This is just a test run on how we can utilize clearData within the contactsVC
    func clearData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        do {
            let userProfiles = try(managedObjectContext.fetch(fetchRequest)) as? [UserProfile]
            for userProfile in userProfiles! {
                managedObjectContext.delete(userProfile)
            }
        } catch let err {
            print(err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewProfileController = ViewProfileController()
        
        if let userProfile = userProfiles?[indexPath.item] {
            viewProfileController.userProfile = userProfile
        }

        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewProfileController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(viewProfileController, animated: true)
    }


}

// Deprecated code that was initially used to retrict the boundaries of the scroll and the last cell.
/*
// This is so that the last item doesnt get hidden by the bottom navigation bar
collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

// This is so that the scrolling animation doesnt bleed into the bottom navigation bar.
// Instead it ends at the bottom navigation bar.
collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
 */

// Deprecated code that was initially used to create the navigation bar. -- Youtube style
/*
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
 */
