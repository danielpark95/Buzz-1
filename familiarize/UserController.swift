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

extension Notification.Name {
    static let reloadCards = Notification.Name("reloadCardsNotification")
}

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
        //self.reloadCards()
        delegate.previousIndex = 0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Me"
        
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards), name: .reloadCards, object: nil)
        
        let user1: JSON = [
            "name": "T.J. Miller",
            "pn": "pn",
            "fb": "100015503711138",
            "sc": "sc",
            "ig": "ig",
            "so": "so",
            "tw": "tw",
            "bio": "Miller the professional chiller.",
            "pia": "fb",
            "piu": "100015503711138",
        ]
        
        let user2: JSON = [
            "name": "Todd Joseph Miller",
            "bio": "Founder & CEO, Aviato.",
            "pn": "pn",
            "in": "in",
            "em": "em",
            ]
        
        //UserProfile.clearData(forProfile: .myUser)
        //UserProfile.clearData(forProfile: .otherUser)
        //UserProfile.saveProfile(user2, forProfile: .myUser)
        //UserProfile.saveProfile(user1, forProfile: .myUser)

        myUserProfiles = UserProfile.getData(forUserProfile: .myUser)
        setupView()
        setupNavBarButton()
        setupCollectionView()
        
        let doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didDoubleTapCollectionView))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView?.addGestureRecognizer(doubleTapGesture)
    }
    
    // This is for when use double taps on the screen, then the card flips around to reveal whatever the behind screen is. 
    func didDoubleTapCollectionView(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView = gesture.location(in: collectionView)
        let selectedIndexPath = collectionView?.indexPathForItem(at: pointInCollectionView)
        let selectedCell = collectionView?.cellForItem(at: selectedIndexPath!) as! UserCell
        selectedCell.onQRImage = !selectedCell.onQRImage
        selectedCell.flipCard()
    }
    
    func setupNavBarButton() {
        let hamburgerButton = UIBarButtonItem(image: UIImage(named:"dan_hamburger_button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleHamburger))
        let addButton = UIBarButtonItem(image: UIImage(named:"add-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNewCard))
        
        navigationItem.leftBarButtonItem = hamburgerButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    lazy var settingsLauncher: SettingsController = {
        let launcher = SettingsController()
        launcher.userController = self
        return launcher
    }()
    
    func handleHamburger() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            UIApplication.shared.isStatusBarHidden = true            
        }, completion: nil)
        settingsLauncher.showSettings()
    }
    
    func closingHamburger() {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func handleNewCard() {
        let layout = UICollectionViewFlowLayout()
        let newCardController = NewCardController(collectionViewLayout: layout)
        let navigationController = UINavigationController.init(rootViewController: newCardController)
        self.present(navigationController, animated: true)
    }
    
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
    
    let headerBar: UIImageView = {
        let image = UIManager.makeImage(imageName: "dan_header_bar")
        image.contentMode = .scaleAspectFit
        return image
    }()

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
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: self.cellId)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
    }
    
    // This is so that the dots that animate your current location can be seen. Amazing piece of art (:
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.pageIndicatorTintColor = UIColor(red: 222/255, green: 223/255, blue: 224/255, alpha: 1.0)
        pc.currentPageIndicatorTintColor = UIColor(red:139/255.0, green: 139/255.0, blue: 139/255.0, alpha: 1.0)
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.isUserInteractionEnabled = false
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! UserCell
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
    
    func reloadCards() {
        myUserProfiles = UserProfile.getData(forUserProfile: .myUser)
        collectionView?.reloadData()
    }

}

