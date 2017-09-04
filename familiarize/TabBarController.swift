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

extension RevealingSplashView {
    
    
    /**
     Retuns the default zoom out transform to be use mixed with other transform
     
     - returns: ZoomOut fransfork
     */
    fileprivate func getZoomOutTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }
    
    func playZoomOutAnimation(_ completion: SplashAnimatableCompletion? = nil)
    {
        if let imageView =  imageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            
            UIView.animate(withDuration: growDuration, animations:{
                
                imageView.transform = self.getZoomOutTranform()
                self.alpha = 0
                
                //When animation completes remote self from super view
            }, completion: { finished in
                
                self.removeFromSuperview()
                
                //backgroundImage.removeFromSuperview()
                completion?()
            })
        }
    }
}

class TabBarController: ESTabBarController, UITabBarControllerDelegate {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeScanner), name: .removeScanner, object: nil)
        
        let backgroundImage: UIImageView = {
            let image = UIManager.makeImage(imageName: "background")
            image.contentMode = .scaleAspectFill
            return image
        }()
        
        self.view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "bee")!,iconInitialSize: CGSize(width: 200, height: 200), backgroundColor: .clear)
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        revealingSplashView.startAnimation(){
            //backgroundImage.removeFromSuperview()
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
            perform(#selector(showWalkthroughController), with: nil, afterDelay: 0)
            //backgroundImage.removeFromSuperview()
        }
    }
    
    
    fileprivate func isNotFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNotFirstTime")
    }
    
    func showWalkthroughController() {
        let walkthroughController = WalkthroughController()
        present(walkthroughController, animated: false, completion: nil)
    }

    func removeScanner() {
        viewControllers?.remove(at: 1)
        //Scanner Controller
        let scannerController = ScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_yellow_25"), selectedImage: UIImage(named: "dan_tabbarcircle_yellow_25"))
        viewControllers?.insert(scannerNavigationController, at: 1)
    }
}
