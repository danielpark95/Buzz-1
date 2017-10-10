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
import Firebase
import Alamofire

extension Notification.Name {
    static let reloadMeCards = Notification.Name("reloadMeCards")
}

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    private var blockOperations = [BlockOperation]()
    
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        fetchRequest.predicate = NSPredicate(format: "userProfileSelection == %@", argumentArray: [UserProfile.userProfileSelection.myUser.rawValue])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named:"dan_editbutton_orange")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(editCard))
    }()
    
    lazy var addButton: UIBarButtonItem = {
       return UIBarButtonItem(image: UIImage(named:"dan_addbutton_orange")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addCard))
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMeCards), name: .reloadMeCards, object: nil)
        navigationItem.title = "Me"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.previousIndex = 0
    }
    
    
    let httpURL: String = "https://qrcode-monkey.p.mashape.com/qr/custom"
    let httpHeader: HTTPHeaders = [
        "X-Mashape-Key": "KT41kN7vl7mshiGSRoAZ3gU2UZpIp1dT1vgjsnqHC0CQqRL0ys",
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    let httpBody: Parameters = [
        "data": "https://www.qrcode-monkey.com",
        "config": [
            "body": "circle-zebra-vertical",
            "eye": "frame13",
            "eyeBall": "ball15",
            "erf1": [],
            "erf2": [],
            "erf3": [],
            "brf1": [],
            "brf2": [],
            "brf3": [],
            "bodyColor": "#0277BD",
            "bgColor": "#FFFFFF",
            "eye1Color": "#075685",
            "eye2Color": "#075685",
            "eye3Color": "#075685",
            "eyeBall1Color": "#0277BD",
            "eyeBall2Color": "#0277BD",
            "eyeBall3Color": "#0277BD",
            "gradientColor1": "#075685",
            "gradientColor2": "#0277BD",
            "gradientType": "linear",
            "gradientOnEyes": false,
            "logo": "#facebook"
        ],
        "size": 300,
        "download": false,
        "file": "png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        Alamofire.request(httpURL, method: .post, parameters: httpBody, encoding: JSONEncoding.default, headers: httpHeader).responseData(completionHandler: { (responseData) in
            print(responseData)
            print("RESPONSE WAS RECEIEVED")
            if let data = responseData.result.value {
                print("RESPONSE WAS RECEIEVED")
                let image = UIImage(data: data)
                let imageView = UIImageView(image: image)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(imageView)
                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            }
        })
    
    
        
        FirebaseManager.sendCard(receiverUID: "ryJYEdZ13AepOeqpD86AhGj2M3f2", cardUID: 13121340415180362844)
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20)!]
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }

        setupView()
        setupNavBarButton()
        setupCollectionView()
        
        let doubleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didDoubleTapCollectionView))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView?.addGestureRecognizer(doubleTapGesture)
    }
    
    func reloadMeCards() {
        do {
            try fetchedResultsController.performFetch()
            setupNavBarButton()
        } catch let err {
            print(err)
        }
    }
    
    // This is for when you use double taps on the screen, then the card flips around to reveal whatever the behind screen is.
    func didDoubleTapCollectionView(_ gesture: UITapGestureRecognizer) {
        let pointInCollectionView = gesture.location(in: collectionView)
        let selectedIndexPath = collectionView?.indexPathForItem(at: pointInCollectionView)
        let selectedCell = collectionView?.cellForItem(at: selectedIndexPath!) as! UserCell
        selectedCell.onQuikklyCode = !(selectedCell.onQuikklyCode)
        selectedCell.setupViews()
    }
    
    // Only display the edit button when the user has created at least one card
    func setupNavBarButton() {
        if fetchedResultsController.fetchedObjects?.count != 0 {
            navigationItem.leftBarButtonItem = editButton
        } else {
            navigationItem.leftBarButtonItem = nil
        }
        navigationItem.rightBarButtonItem = addButton
    }
    
    func editCard() {
        let newCardController = NewCardController()
        let navigationController = UINavigationController(rootViewController: newCardController)
        newCardController.socialMediaInputs.removeAll(keepingCapacity: true)
        newCardController.navigationItem.title = "Edit Card"
        
        let initialPinchPoint = CGPoint(x: (self.collectionView?.center.x)! + (self.collectionView?.contentOffset.x)!, y: (self.collectionView?.center.y)! + (self.collectionView?.contentOffset.y)!)
        
        // Select the chosen image from the collectionview
        let selectedIndexPath = collectionView?.indexPathForItem(at: initialPinchPoint)
        let userProfile = fetchedResultsController.object(at: selectedIndexPath!) as! UserProfile
        newCardController.editingUserProfile = userProfile
        
        for appName in userProfile.entity.propertiesByName.keys {
            guard let inputName = userProfile.value(forKey: appName) else { continue }
            guard let ranking = newCardController.socialMediaTableViewRanking[appName] else { continue }
            if UserProfile.editableMultipleInputUserData.contains(appName) {
                for eachInput in inputName as! [String] {
                    let socialMediaInput = SocialMedia(withAppName: appName, withImageName: "dan_\(appName)_add", withInputName: eachInput, withAlreadySet: false, withRanking: ranking)
                    newCardController.addSocialMediaInput(socialMedia: socialMediaInput)
                }
            } else if UserProfile.editableSingleInputUserData.contains(appName) {
                let socialMediaInput = SocialMedia(withAppName: appName, withImageName: "dan_\(appName)_black", withInputName: inputName as! String, withAlreadySet: false, withRanking: ranking)
                newCardController.addSocialMediaInput(socialMedia: socialMediaInput)
            }
        }
        newCardController.socialMediaInputs.sort(by: {$0.ranking < $1.ranking})
        present(navigationController, animated: true)
    }
    
    func addCard() {
        let newCardController = NewCardController()
        let navigationController = UINavigationController(rootViewController: newCardController)
        newCardController.navigationItem.title = "New Card"
        self.present(navigationController, animated: true)
    }

    func setupView() {
        // Add the dots that animate your current location with the qrcodes into the view
        view.addSubview(pageControl)
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupCollectionView() {
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: self.cellId)
        collectionView?.isPagingEnabled = true
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        } else if type == .update {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.reloadItems(at: [newIndexPath!])
            }))
        } else if type == .delete {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.deleteItems(at: [indexPath!])
                self.setupNavBarButton()
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: nil)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Modify this after you saved a user.
        if let count = fetchedResultsController.sections?.first?.numberOfObjects {
            pageControl.numberOfPages = count
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! UserCell
        let userProfile = fetchedResultsController.object(at: indexPath) as! UserProfile
        cell.myUserProfile = userProfile
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView!.frame.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

