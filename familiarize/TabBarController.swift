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
class TabBarController: ESTabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let tabBarController = ESTabBarController()
        //tabBarController.delegate = self
        tabBarController.tabBar.shadowImage = UIImage(named: "dan_transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "dan_background")
        
        //User Controller
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        //userNavigationController.tabBarItem.image = UIImage(named: "dan_me_grey")?.withRenderingMode(.alwaysOriginal)
        //userNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_me_black")?.withRenderingMode(.alwaysOriginal)
        userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "dan_myinfo_grey"), selectedImage: UIImage(named: "dan_myinfo_grey"))
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0 )
        
        //Scanner Controller
        let scannerController = QRScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        //scannerNavigationController.tabBarItem.image = UIImage(named: "dan_camera_round")?.withRenderingMode(.alwaysOriginal)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: "Camera", image: UIImage(named: "dan_camera_round"), selectedImage: UIImage(named: "dan_camera_round"))
        scannerNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        //Contacts Controller
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        //contactsNavigationController.tabBarItem.image = UIImage(named: "dan_friends_grey")?.withRenderingMode(.alwaysOriginal)
        //contactsNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_friends_black")?.withRenderingMode(.alwaysOriginal)
        contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Friends", image: UIImage(named: "dan_contacts_grey"), selectedImage: UIImage(named: "dan_contacts_grey"))
        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
        
    }
}
