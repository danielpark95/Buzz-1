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
extension Notification.Name {
    static let removeScanner = Notification.Name("removeScanner")
}

class TabBarController: ESTabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "bee")!,iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: UIColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha:1.0))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        revealingSplashView.startAnimation(){
        }
      
        if isNotFirstTime() {
            let tabBarController = ESTabBarController()
            tabBarController.tabBar.isTranslucent = false
            tabBarController.tabBar.barTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha:1.0)
            //User Controller
            let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
            let userNavigationController = UINavigationController(rootViewController: userController)
            userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "dan_me_grey"), selectedImage: UIImage(named: "dan_me_black"))
            
            //Scanner Controller
            let scannerController = ScannerController()
            let scannerNavigationController = UINavigationController(rootViewController: scannerController)
            scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_yellow_25"), selectedImage: UIImage(named: "dan_tabbarcircle_yellow_25"))
            
            //Contacts Controller
            let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
            let contactsNavigationController = UINavigationController(rootViewController: contactsController)
            contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "dan_friends_grey"), selectedImage: UIImage(named: "dan_friends_black"))
            
            viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
        } else {
            perform(#selector(showWalkthroughController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isNotFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNotFirstTime")
    }
    
    func showWalkthroughController() {
        let walkthroughController = WalkthroughController()
        present(walkthroughController, animated: true, completion: nil)

    }

    func removeScanner() {
        viewControllers?.remove(at: 1)
        //Scanner Controller
        let scannerController = ScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_teal"), selectedImage: UIImage(named: "dan_tabbarcircle_teal"))
        viewControllers?.insert(scannerNavigationController, at: 1)
        self.updateFocusIfNeeded()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "bee")!,iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: UIColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha:1.0))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        revealingSplashView.startAnimation(){
        }
}
