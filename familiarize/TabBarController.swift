//
//  TabBarController.swift
//  familiarize
//
//  Created by Daniel Park on 7/9/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import ESTabBarController_swift
extension ESTabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
extension Notification.Name {
    static let removeScanner = Notification.Name("removeScanner")
}

class TabBarController: ESTabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(removeScanner), name: .removeScanner, object: nil)
        
        let tabBarController = ESTabBarController()
        tabBarController.tabBar.isTranslucent = false
        
        //User Controller
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "dan_myinfo_grey"), selectedImage: UIImage(named: "dan_myinfo_salmon"))
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0 )
        
        //Scanner Controller
        let scannerController = ScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_teal"), selectedImage: UIImage(named: "dan_tabbarcircle_teal"))
        
        //Contacts Controller
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Friends", image: UIImage(named: "dan_contacts_grey"), selectedImage: UIImage(named: "dan_contacts_salmon"))
        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
    }
    
    func removeScanner() {
        viewControllers?.remove(at: 1)
        //Scanner Controller
        let scannerController = ScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_teal"), selectedImage: UIImage(named: "dan_tabbarcircle_teal"))
        viewControllers?.insert(scannerNavigationController, at: 1)
        self.updateFocusIfNeeded()
    }
}
