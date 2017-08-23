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


protocol ContactsControllerDelegate {
    func closeHamburger()
    func showControllerForSetting(setting: Setting)
}

class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, NSFetchedResultsControllerDelegate, ContactsControllerDelegate {
    
    private let cellId = "cellId"
    var blockOperations = [BlockOperation]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(ContactsController.refreshTableData(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.predicate = NSPredicate(format: "userProfileSelection == %@", argumentArray: [UserProfile.userProfileSelection.otherUser.rawValue])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
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
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        navigationItem.title = "Friends"
        //userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        setupCollectionView()
        setupRefreshingAndReloading()
        setupNavBarButton()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 2
    }
    
    func setupNavBarButton() {
        let hamburgerButton = UIBarButtonItem(image: UIImage(named:"dan_editbutton_yellow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(openHamburger))
        navigationItem.rightBarButtonItem = hamburgerButton
    }
    
    lazy var settingsLauncher: SettingsController = {
        let launcher = SettingsController()
        launcher.contactsControllerDelegate = self
        return launcher
    }()
    
    func closeHamburger() {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func openHamburger() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            UIApplication.shared.isStatusBarHidden = true
        }, completion: nil)
        settingsLauncher.setupViews()
    }
    
    func showControllerForSetting(setting: Setting) {
        
        let layout = UICollectionViewFlowLayout()
        let controller: UIViewController
        
        if setting.name == .TermsPrivacy {
            controller = TermsPrivacySettingController(collectionViewLayout: layout)
        } else if setting.name == .Contact {
            controller = ContactSettingController(collectionViewLayout: layout)
        } else if setting.name == .Help {
            controller = HelpSettingController(collectionViewLayout: layout)
        } else { // It is the feedback controller
            controller = FeedbackSettingController(collectionViewLayout: layout)
        }
        
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func viewProfileNotification() {
        viewProfile()
    }
    
    func reloadTableData() {
        //userProfiles = UserProfile.getData(forUserProfile: .otherUser)
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
    
    func viewProfile(_ indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        //userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        let viewProfileController = ViewProfileController()
        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewProfileController.userProfile = userProfile
        
        self.definesPresentationContext = true
        self.tabBarController?.present(viewProfileController, animated: false, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewProfile(indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ContactsCell
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        cell.userProfile = userProfile
        return cell
    }
}
