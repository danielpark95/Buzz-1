////
////  ExampleProvider.swift
////  familiarize
////
////  Created by Daniel Park on 7/9/17.
////  Copyright © 2017 nosleep. All rights reserved.
////
//
//import UIKit
//import ESTabBarController_swift
//
//enum ExampleProvider {
//    static func customIrregularityStyle(delegate: UITabBarControllerDelegate?) ->
//        ExampleNavigationController {
//            let tabBarController = ESTabBarController()
//            tabBarController.delegate = delegate
//            tabBarController.title = "Example"
//            tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
//            tabBarController.tabBar.backgroundImage = UIImage(named: "background")
//            let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
//            let scannerController = QRScannerController()
//            let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
//            userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "dan_me_grey"), selectedImage: UIImage(named: "dan_me_black"))
//            scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "dan_camera_round"), selectedImage: UIImage(named: "dan_camera_round"))
//            contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Friends", image: UIImage(named: "dan_friends_grey"), selectedImage: UIImage(named: "dan_friends_black"))
//            tabBarController.viewControllers = [userController, scannerController, contactsController]
//            let navigationController = UINavigationController.init(rootViewController: tabBarController)
//            tabBarController.title = "Tab Bar"
//            return navigationController as! ExampleNavigationController
//    }
//}
