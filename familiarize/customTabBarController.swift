//
//  customTabBarController.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
extension UITabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsNavigationController.tabBarItem.image = UIImage(named: "dan_contacts_grey")?.withRenderingMode(.alwaysOriginal)
        contactsNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_contacts_red")?.withRenderingMode(.alwaysOriginal)
        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)

        let famController = QRScannerController()
        let famNavigationController = UINavigationController(rootViewController: famController)
        famNavigationController.tabBarItem.image = UIImage(named: "dan_camera_round")?.withRenderingMode(.alwaysOriginal)
        famNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userNavigationController.tabBarItem.image = UIImage(named: "dan_myinfo_grey")?.withRenderingMode(.alwaysOriginal)
        userNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_myinfo_red")?.withRenderingMode(.alwaysOriginal)
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        viewControllers = [contactsNavigationController, famNavigationController, userNavigationController]
        
        createSmallLineOnTabBar()
        tabBar.backgroundColor = UIColor.white
    }
    
    func tabBarController(_ didSelecttabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController {
            vc.dismiss(animated: false)
        }
    }

    func createSmallLineOnTabBar() {
        tabBar.isTranslucent = false
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 55
        tabFrame.origin.y = self.view.frame.size.height - 55
        self.tabBar.frame = tabFrame
    }
    

}


