//
//  customTabBarController.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // "Search-50", "Fam-100-Border-Decrease", "User-50"
        
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: contactsController)
        navigationController.tabBarItem.image = UIImage(named: "Search-50")?.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        
        
        let famController = FamiliarizeController(collectionViewLayout: UICollectionViewFlowLayout())
        let secondNavigationController = UINavigationController(rootViewController: famController)
        secondNavigationController.tabBarItem.image = UIImage(named: "Fam-100-Border-Decrease")?.withRenderingMode(.alwaysOriginal)
        secondNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        
        let userVC = UIViewController()
        userVC.navigationItem.title = "Profile"
        let userNavigationController = UINavigationController(rootViewController: userVC)
        userNavigationController.tabBarItem.image = UIImage(named: "User-50")?.withRenderingMode(.alwaysOriginal)
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
        
        
        viewControllers = [navigationController, secondNavigationController, userNavigationController]
        
        tabBar.isTranslucent = false
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
//
    }
    override func viewWillLayoutSubviews() {
        
        var tabFramey = self.tabBar.frame
        tabFramey.size.height = 38
        tabFramey.origin.y = self.view.frame.size.height - 38
        self.tabBar.frame = tabFramey
    }
    
    
}

