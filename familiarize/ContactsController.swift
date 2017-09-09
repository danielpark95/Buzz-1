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
    static let reloadFriendCards = Notification.Name("reloadFriendCards")
    static let viewProfile = Notification.Name("viewProfileNotification")
}


protocol ContactsControllerDelegate {
    func closeHamburger()
    func showControllerForSetting(setting: Setting)
}

class ContactsController: UITableViewController, NSFetchedResultsControllerDelegate, ContactsControllerDelegate {
    
    private let cellId = "cellId"
    
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
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        NotificationCenter.default.addObserver(self, selector: #selector(viewProfileNotification), name: .viewProfile, object: nil)
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFriendCards), name: .reloadFriendCards, object: nil)
        navigationItem.title = "Friends"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20)!]
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
        setupTableView()
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
    
    func reloadFriendCards() {
        tableView.reloadData()
    }
    
    func refreshTableData(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    func setupTableView() {
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        tableView.register(ContactsCell.self, forCellReuseIdentifier: self.cellId)
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        DiskManager.deleteImageFromLocal(withUniqueID: userProfile.uniqueID as! UInt64)
        UserProfile.deleteProfile(user: userProfile)
    }
    
    func setupRefreshingAndReloading() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action:#selector(ContactsController.refreshTableData(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }
    }
    
    func viewProfile(_ indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        //userProfiles = UserProfile.getData(forUserProfile: .otherUser)
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        
        let viewProfileController = ViewProfileController()
        viewProfileController.socialMediaInputs = [SocialMedia]()
        for key in userProfile.entity.propertiesByName.keys {
            guard let inputName = userProfile.value(forKey: key) else {
                continue
            }
            if UserProfile.editableMultipleInputUserData.contains(key) {
                for eachInput in inputName as! [String] {
                    let socialMediaInput = SocialMedia(withAppName: key, withImageName: "dan_\(key)_color", withInputName: eachInput, withAlreadySet: true)
                    print(socialMediaInput.imageName!)
                    viewProfileController.socialMediaInputs?.append(socialMediaInput)
                }
            }
        }
        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewProfileController.userProfile = userProfile
        
        definesPresentationContext = true
        tabBarController?.present(viewProfileController, animated: false, completion: nil)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        } else if type == .delete {
            tableView.deleteRows(at: [indexPath!], with: .fade)
        } else if type == .update {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewProfile(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactsCell
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        cell.userProfile = userProfile
        cell.selectionStyle = .none
        return cell
    }
}
