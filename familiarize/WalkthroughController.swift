//
//  WalkthroughController.swift
//  familiarize
//
//  Created by Daniel Park on 8/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift
import Cheers

protocol walkThroughControllerDelegate : class {
    func finishWalkthrough()
}

class WalkthroughController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, walkThroughControllerDelegate {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let cheerView = CheerView()
    var isLastPage = false
    
    let cellId = "cellId"
    let startCellId = "startCellId"
    
    let walkthroughs: [Walkthrough] = {
        let firstWalkthrough = Walkthrough(title: "Welcome to Buzz!", message: "A better way to connect with people.", imageName: "pg1_new")
        
        let secondWalkthrough = Walkthrough(title: "Create personalized profiles", message: "Social, business, or anything else can be easily customized.", imageName: "pg2_new")
        
        let thirdWalkthrough = Walkthrough(title: "Double tap to reveal code!", message: "Then scan to add automatically.", imageName: "pg3_new")
        
        return [firstWalkthrough, secondWalkthrough, thirdWalkthrough]
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red:255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
        pc.numberOfPages = 3
        return pc
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        //print(pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1])
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[3]
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        registerCells()
        
        
        
        if isLastPage == true {
            cheerView.config.particle = .confetti
            view.addSubview(cheerView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cheerView.frame = view.bounds
    }
    
    fileprivate func registerCells() {
        
        collectionView.register(WalkthroughCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(WalkthroughStartCell.self, forCellWithReuseIdentifier: startCellId)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == walkthroughs.count {
            //pageControlBottomAnchor?.constant = 0
            pageControl.pageIndicatorTintColor = .clear
            pageControl.currentPageIndicatorTintColor = .clear
            isLastPage = true
            print ("bool = " , isLastPage)
            
            if isLastPage == true {
                cheerView.config.particle = .confetti
                //let image = UIImage(named: "honeycomb")
                //cheerView.config.particle = .image([image!])
                
                //cheerView.config.colors = [UIColor.red, UIColor.yellow, UIColor.green, UIColor.blue]
                
                view.addSubview(cheerView)
                
                cheerView.start()
            }
        } else {
            pageControlBottomAnchor?.constant = 40
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = UIColor(red:255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
            isLastPage = false
            if isLastPage == false {
                cheerView.stop()
            }
        }
        //UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
        //    self.view.layoutIfNeeded()
        //}, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return walkthroughs.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == walkthroughs.count {
            let startCell = collectionView.dequeueReusableCell(withReuseIdentifier: startCellId, for: indexPath) as! WalkthroughStartCell
            //startCell.walkthroughController = self
            startCell.delegate = self
            return startCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WalkthroughCell
        
        let walkthrough = walkthroughs[indexPath.item]
        cell.walkthrough = walkthrough
        
        return cell
    }
    
    
    func finishWalkthrough() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        UserDefaults.standard.set(true, forKey: "isNotFirstTime")
        UserDefaults.standard.synchronize()
        
        guard let mainNavigationController = rootViewController as? TabBarController else { return }
        
        let tabBarController = ESTabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha:1.0)
        //User Controller
        let userController = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavigationController = UINavigationController(rootViewController: userController)
        userController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "dan_me_grey"), selectedImage: UIImage(named: "dan_me_black"))
        //userNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        userNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 30, 0, -10)
        
        //Scanner Controller
        let scannerController = ScannerController()
        let scannerNavigationController = UINavigationController(rootViewController: scannerController)
        scannerController.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(),title: nil, image: UIImage(named: "dan_tabbarcircle_yellow_25"), selectedImage: UIImage(named: "dan_tabbarcircle_yellow_25"))
        //scannerNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(-16,0,0,0)
        
        //Contacts Controller
        let contactsController = ContactsController(collectionViewLayout: UICollectionViewFlowLayout())
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        contactsController.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: nil, image: UIImage(named: "dan_friends_grey"), selectedImage: UIImage(named: "dan_friends_black"))
        //contactsNavigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        mainNavigationController.viewControllers = [userNavigationController, scannerNavigationController, contactsNavigationController]
        
        //mainNavigationController.viewControllers = [TabBarController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
