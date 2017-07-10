//
//  UserController.swift
//  familiarize
//
//  Created by Alex Oh on 6/17/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    
    var myUserProfiles: [UserProfile]? {
        didSet {
            if let count = self.myUserProfiles?.count {
                pageControl.numberOfPages = count
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 2
    }
    
    override func viewDidLoad() {
        
        let stuff: JSON = [
            "name": "T.J. Miller",
            "pn": "pn",
            "fb": "fb",
            "sc": "sc",
            "ig": "ig",
            "so": "so",
            "tw": "tw",
            "bio": "Miller the professional chiller."
            ]
        
        let pika: JSON = [
            "name": "Todd Joseph Miller",
            "pn": "pn",
            "in": "in",
            "em": "em",
            "bio": "Founder & CEO, Aviato.",
        ]
        UserProfile.clearData(forProfile: .myUser)
        UserProfile.saveProfile(pika, forProfile: .myUser)
        UserProfile.saveProfile(stuff, forProfile: .myUser)
        
        
        super.viewDidLoad()
        navigationItem.title = "Me"
        
        
        setupNavBarButton()
        self.automaticallyAdjustsScrollViewInsets = false
        
        myUserProfiles = UserProfile.getData(forUserProfile: .myUser)
        setupView()
        setupCollectionView()
        //createSmallLineOnTabBar()
        
        let doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didDoubleTapCollectionView))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView?.addGestureRecognizer(doubleTapGesture)
    }
    
    // This is for when use double taps on the screen, then the card flips around to reveal whatever the behind screen is. 
    func didDoubleTapCollectionView(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView = gesture.location(in: collectionView)
        let selectedIndexPath = collectionView?.indexPathForItem(at: pointInCollectionView)
        let selectedCell = collectionView?.cellForItem(at: selectedIndexPath!) as! FamiliarizeCell
        
        selectedCell.flip()
    }
    
    func setupNavBarButton() {
        let hamburgerButton = UIBarButtonItem(image: UIImage(named:"settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleHamburger))
        navigationItem.rightBarButtonItem = hamburgerButton
    }
    
//    func handleHamburger() {
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
//        
//        let layout = UICollectionViewFlowLayout()
//        let controller = SettingsController(collectionViewLayout: layout)
//        let navigationController = UINavigationController.init(rootViewController: controller)
//        self.present(navigationController, animated: false)
//    }
    
    lazy var settingsLauncher: SettingsController = {
        let launcher = SettingsController()
        launcher.userController = self
        return launcher
    }()
    
    func handleHamburger() {
        settingsLauncher.showSettings()
    }
    
    
    /*
 
 case Blank = ""
 case TermsPrivacy = "Terms & privacy policy"
 case Contact = "Contact"
 case Help = "Help"
 case Feedback = "Feedback"
 */
    func showControllerForSetting(setting: Setting) {

        let layout = UICollectionViewFlowLayout()
        let controller: UIViewController
        
        if setting.name == .TermsPrivacy {
            controller = TermsPrivacySettingController(collectionViewLayout: layout)
        } else if setting.name == .Contact {
            controller = ContactSettingController(collectionViewLayout: layout)
        } else if setting.name == .Help {
            controller = HelpSettingController(collectionViewLayout: layout)
        } else { // It is the feedback controller
            controller = FeedbackSettingController(collectionViewLayout: layout)
        }
        
        
        controller.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(controller, animated: true)
    }
    
    

    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FamiliarizeCell.self, forCellWithReuseIdentifier: self.cellId)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
        
    }
    
    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor(red: 222/255, green: 223/255, blue: 224/255, alpha: 1.0)
        pc.currentPageIndicatorTintColor = UIColor(red:139/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1.0)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Modify this after you saved a user.
        if let count = self.myUserProfiles?.count {
            return count
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! FamiliarizeCell
        
        if let myUserProfile = myUserProfiles?[indexPath.item] {
            cell.myUserProfile = myUserProfile
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView!.frame.size;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func createSmallLineOnTabBar() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0)
        topBorder.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0).cgColor
        tabBarController?.tabBar.layer.addSublayer(topBorder)
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.clipsToBounds = true
    }

    
}

