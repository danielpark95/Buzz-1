//
//  TabBarController.swift
//  familiarize
//
//  Created by Daniel Park on 7/9/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import RevealingSplashView

extension ESTabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
class TabBarController: ESTabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "handshakelogo_white")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red: 165/255.0, green: 213/255.0, blue: 201/255.0, alpha:1.0))
        //revealingSplashView.useCustomIconColor = true
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        self.delegate = self
        

        
        let tabBarController = ESTabBarController()
        tabBarController.tabBar.isTranslucent = false
        
        //User Controller
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "", image: UIImage(named: "dan_me_grey"), selectedImage: UIImage(named: "dan_me_softblack"))
        //userNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 30, 0, -10)
        
        //Scanner Controller
        let scannerController = QRScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_lightgreen"), selectedImage: UIImage(named: "dan_tabbarcircle_lightgreen"))
        //scannerNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(-16,0,0,0)
        
        //Contacts Controller
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "", image: UIImage(named: "dan_friends_grey"), selectedImage: UIImage(named: "dan_friends_softblack"))
        //contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
        
    }
}
