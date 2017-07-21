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
        
        tabBarController.tabBar.layer.borderWidth = 1.0
        tabBarController.tabBar.isTranslucent = false
        
        //User Controller
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "dan_myinfo_grey"), selectedImage: UIImage(named: "dan_myinfo_grey"))
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0 )
        
        //Scanner Controller
        let scannerController = QRScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_camera_84"), selectedImage: UIImage(named: "dan_camera_84"))
        
        let img = UIImage(named: "dan_camera_84")
        print("width = ", img?.size.width)
        print("height = ", img?.size.height)
        
        
        //scannerNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(-16,0,0,0)
        
        //Contacts Controller
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Friends", image: UIImage(named: "dan_contacts_grey"), selectedImage: UIImage(named: "dan_contacts_grey"))
        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
        
    }
}
