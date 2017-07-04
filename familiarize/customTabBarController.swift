//
//  customTabBarController.swift
//  familiarize
//
//  Created by Alex Oh on 5/29/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import ESTabBarController_swift

extension UITabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate  {
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
//        
//        let tabBarController = ESTabBarController()
//        self.delegate = self
//        tabBarController.title = "Irregularity"
//        tabBarController.tabBar.shadowImage = UIImage(named: "dan_transparent")
//        tabBarController.tabBar.backgroundImage = UIImage(named: "dan_background")
//        tabBarController.shouldHijackHandler = {
//            tabbarController, viewController, index in
//            if index == 1 {
//                return true
//            }
//            return false
//        }
//        tabBarController.didHijackHandler = {
//            [weak tabBarController] tabbarController, viewController, index in
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
//                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
//                alertController.addAction(takePhotoAction)
//                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
//                alertController.addAction(selectFromAlbumAction)
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                alertController.addAction(cancelAction)
//                tabBarController?.present(alertController, animated: true, completion: nil)
//            }
//        }
//        
//        let v1 = UserController()
//        //let v2 = ExampleViewController()
//        let v3 = QRScannerController()
//        //let v4 = ExampleViewController()
//        let v5 = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
//        
//        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "My Info", image: UIImage(named: "dan_myinfo_grey"), selectedImage: UIImage(named: "dan_myinfo_red"))
//        //v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
//        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "dan_camera"), selectedImage: UIImage(named: "dan_camera"))
//        //v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
//        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Contacts", image: UIImage(named: "dan_contacts_grey"), selectedImage: UIImage(named: "dan_contacts_red"))
//        
//        tabBarController.viewControllers = [v1, v3, v5]
//        
//        //let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
//        tabBarController.title = "My Info"
//        //self.window?.rootViewController = navigationController

        
        
        
        
        
        
//        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
//        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
//        contactsNavigationController.tabBarItem.image = UIImage(named: "dan_contacts_grey")?.withRenderingMode(.alwaysOriginal)
//        contactsNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_contacts_red")?.withRenderingMode(.alwaysOriginal)
//        contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
//        
//        let famController = QRScannerController()
//        let famNavigationController = UINavigationController(rootViewController: famController)
//        famNavigationController.tabBarItem.image = UIImage(named: "dan_camera_round")?.withRenderingMode(.alwaysOriginal)
//        famNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
//        
//        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
//        let userNavigationController = UINavigationController(rootViewController: userController)
//        userNavigationController.tabBarItem.image = UIImage(named: "dan_myinfo_grey")?.withRenderingMode(.alwaysOriginal)
//        userNavigationController.tabBarItem.selectedImage = UIImage(named: "dan_myinfo_red")?.withRenderingMode(.alwaysOriginal)
//        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
//        
//        let tabBackground = UIManager.makeImage(imageName: "dan_orange_bar")
//        self.tabBar.addSubview(tabBackground)
//        tabBackground.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
//        tabBackground.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
//        
//        tabBackground.widthAnchor.constraint(equalToConstant: tabBar.frame.width - 20).isActive = true
//        tabBackground.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        tabBackground.contentMode = .scaleAspectFill
//
//        viewControllers = [contactsNavigationController, famNavigationController, userNavigationController]
//        
//        createSmallLineOnTabBar()
//        tabBar.backgroundColor = UIColor.white
        
        
        
        
        
 
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
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0)
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


