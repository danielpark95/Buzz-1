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
    
    var myUserProfiles: [MyUserProfile]? {
        didSet {
            if let count = self.myUserProfiles?.count {
                pageControl.numberOfPages = count
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 0
    }
    
    override func viewDidLoad() {
        
        
        
        let stuff: JSON = [
            "name": "alex",
            "fb": "alexswoh",
            "ig": "l",
            "sc": "s",
            "pn": "123123",
            "bio": "Hello",
            "in": "hi",
            "em": "ell"
        ]
        
        let pika: JSON = [
            "name": "eric chung",
            "fb": "eric.chung.5680",
            "ig": "l",
            "sc": "s",
            "pn": "123123",
            "bio": "Hello",
            "in": "hi",
            "em": "ell"
        ]
        MyUserProfile.clearData()
        MyUserProfile.saveData(stuff)
        MyUserProfile.saveData(pika)
        
        
        super.viewDidLoad()
        
        setupNavBarButton()
        navigationItem.title = "My Info"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        myUserProfiles = MyUserProfile.getData()
        setupView()
        setupCollectionView()
        
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
        let hamburgerButton = UIBarButtonItem(image: UIImage(named:"settings-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleHamburger))
        let addButton = UIBarButtonItem(image: UIImage(named:"add-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAdd))
        
        navigationItem.leftBarButtonItem = hamburgerButton
        navigationItem.rightBarButtonItem = addButton
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
    func handleAdd() {
        
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
    
    
    let profileImage: UIImageView = {
        return UIManager.makeProfileImage(valueOfCornerRadius: 30)
    }()
    
    let headerBar: UIImageView = {
        return UIManager.makeImage(imageName: "dan_header_bar")
    }()

    let nameLabel: UILabel = {
        return UIManager.makeLabel(numberOfLines: 1)
    }()
    
    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(headerBar)
        
        
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let name = NSMutableAttributedString(string: "Richard Hendricks", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 25)!, NSForegroundColorAttributeName: UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)])
        
        nameLabel.attributedText = name
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.intrinsicContentSize.height).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant:nameLabel.intrinsicContentSize.width).isActive = true

        
        headerBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -110).isActive = true
        headerBar.heightAnchor.constraint(equalToConstant: 130).isActive = true
        headerBar.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
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
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
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

    
}

